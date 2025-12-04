package customer.conference_management_system.handlers;

import cds.gen.Conference;
import cds.gen.Attendee;
import cds.gen.Attendee_;
import cds.gen.Ticket;
import cds.gen.Ticket_;
import cds.gen.conferenceservice.ConferencesCancelConferenceContext;
import com.sap.cds.ql.Delete;
import com.sap.cds.ql.Select;
import com.sap.cds.ql.cqn.CqnAnalyzer;
import com.sap.cds.ql.cqn.CqnDelete;
import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.reflect.CdsModel;
import com.sap.cds.services.cds.CqnService;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.After;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.messages.Messages;
import com.sap.cds.services.persistence.PersistenceService;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import cds.gen.conferenceservice.Conferences;
import cds.gen.conferenceservice.Conferences_;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
@ServiceName("ConferenceService")
@RequiredArgsConstructor
public class ConferenceServiceHandler implements EventHandler {

    private final NamedParameterJdbcTemplate jdbcTemplate;
    private final PersistenceService persistenceService;
    private final CdsModel model;
    private final Messages messages;


    @Before(event = CqnService.EVENT_CREATE, entity = Conferences_.CDS_NAME)
    public void validateConferenceCreationRequest(Conference conference) {
        validateField(conference.getName(), "Conference name is null or empty",Conference.NAME );
        validateField(conference.getDescription(), "Conference description is null or empty", Conference.DESCRIPTION);
        validateField(conference.getLocation(), "Conference location is null or empty", Conference.LOCATION);
        validateField(conference.getStartDate(), "Conference start date is null", Conference.START_DATE);
        validateField(conference.getEndDate(), "Conference end date is null", Conference.END_DATE);
    }

    private void validateField(Object field, String msg, String target) {
        if (field == null || (field instanceof String && ((String) field).isEmpty())) {
            messages.error(msg, target);
        }
    }

    @Transactional
    @On(event = ConferencesCancelConferenceContext.CDS_NAME)
    public String onCancelConference(ConferencesCancelConferenceContext context) {
        // Extract conference id from url
        CqnAnalyzer analyzer = CqnAnalyzer.create(model);
        Map<String, Object> keys = analyzer.analyze(context.getCqn()).targetKeys();
        String conferenceId = (String) keys.get(Conferences.ID);

        CqnSelect ticketSelectQuery = Select.from(Ticket_.class)
                .where(t -> t.conference_ID().eq(conferenceId));
        List<String> ticketIds = persistenceService.run(ticketSelectQuery).stream()
                .map(row -> row.as(Ticket.class).getId())
                .toList();

        CqnSelect attendeeSelectQuery = Select.from(Attendee_.class)
                .where(a -> a.get(Attendee.TICKET_ID).in(ticketIds));

        List<Attendee> attendees = persistenceService.run(attendeeSelectQuery).stream()
                .map(row -> row.as(Attendee.class))
                .toList();

        attendees.forEach(attendee -> {
            System.out.println("Attendee: " + attendee.getId() + " " + attendee.getFirstName() + " was notified about cancellation");
        });

        // Delete tickets and associated attendees
        CqnDelete ticketDeleteQuery = Delete.from(Ticket_.class).where(t -> t.conference_ID().eq(conferenceId));
        persistenceService.run(ticketDeleteQuery);

        return "Conference successfully cancelled";
    }

    @After(event = CqnService.EVENT_READ, entity = Conferences_.CDS_NAME)
    public void afterRead(List<Conferences> conferences) {

        List<String> confIds = conferences.stream()
                .map(Conferences::getId)
                .toList();

        String query = """
            select c.id as id, count(*) as count
            from conferences c
            join sessions s on s.conference_id = c.id
            where c.id in (:ids)
            group by c.id;
        """;

        MapSqlParameterSource params = new MapSqlParameterSource();
        params.addValue("ids", confIds);

        SqlRowSet rowSet = jdbcTemplate.queryForRowSet(query, params);
        Map<String, Integer> mappedResult = new HashMap<>();

        while (rowSet.next()) {
            String id = rowSet.getString("id");
            Integer count = rowSet.getInt("count");
            mappedResult.put(id, count);
        }

        conferences.forEach(c -> {
            c.setNumOfSessions(mappedResult.get(c.getId()));
        });
    }

}
