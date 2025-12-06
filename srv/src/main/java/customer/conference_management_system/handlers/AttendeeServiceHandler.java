package customer.conference_management_system.handlers;

import cds.gen.my.conference.Attendees;
import cds.gen.my.conference.Attendees_;
import cds.gen.my.conference.Tickets;
import cds.gen.my.conference.TicketType;
import cds.gen.my.conference.Tickets_;
import cds.gen.attendeeservice.AttendeeService_;
import cds.gen.attendeeservice.RegisterAttendeeContext;
import com.sap.cds.Result;
import com.sap.cds.Struct;
import com.sap.cds.ql.Select;
import com.sap.cds.ql.Update;
import com.sap.cds.ql.cqn.CqnInsert;
import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.ql.cqn.CqnUpdate;
import com.sap.cds.services.cds.CqnService;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.persistence.PersistenceService;
import com.sap.cds.ql.Insert;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Component
@ServiceName( AttendeeService_.CDS_NAME )
@RequiredArgsConstructor
public class AttendeeServiceHandler implements EventHandler {

    private final PersistenceService persistenceService;


    @Before(
            event = CqnService.EVENT_CREATE,
            entity = Attendees_.CDS_NAME
    )
    public void beforeCreation(Attendees attendee) {

        Tickets newTicket = Struct.create(Tickets.class);
        newTicket.setType(TicketType.REGULAR);
        newTicket.setPrice(123);
        newTicket.setConference(Map.of("ID", "22cbcaaa-af0c-4ecb-affb-27f487e85674"));

        // Persist the ticket directly using PersistenceService
        Result result = persistenceService.run(
                Insert.into(Tickets_.CDS_NAME).entry(newTicket)
        );
        Tickets savedTicket = result.first().get().as(Tickets.class);

        attendee.setTicket(savedTicket);
    }

    @Transactional
    @On(event = RegisterAttendeeContext.CDS_NAME)
    public void onRegisterAttendee(RegisterAttendeeContext context) {
        CqnSelect query = Select.from(Attendees_.CDS_NAME)
                .where(a -> a.get("ID").eq(context.getAttendeeId()));

        Attendees attendeeEntity = persistenceService.run(query).single(Attendees.class);

        if (attendeeEntity.getTicketId() != null) {
            // Attendee already has a ticket and is already registered, exiting.
            context.setResult("Attendee is already registered");
            return;
        }

        Tickets ticket = Struct.create(Tickets.class);
        ticket.setType(TicketType.REGULAR);
        ticket.setPrice(123);
        ticket.setConference(Map.of("ID", context.getConferenceId()));

        CqnInsert insertQuery = Insert.into(Tickets_.CDS_NAME).entry(ticket);
        Result insertResult = persistenceService.run(insertQuery);
        String ticketId = insertResult.single(Tickets.class).getId();

        attendeeEntity.setTicketId(ticketId);

        CqnUpdate updateQuery = Update.entity(Attendees_.CDS_NAME).entry(attendeeEntity);
        persistenceService.run(updateQuery);

        context.setResult("Attendee was registered to Conference successfully");
    }

}
