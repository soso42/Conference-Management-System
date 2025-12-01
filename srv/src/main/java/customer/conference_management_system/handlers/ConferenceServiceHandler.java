package customer.conference_management_system.handlers;

import com.sap.cds.services.cds.CqnService;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.After;
import com.sap.cds.services.handler.annotations.ServiceName;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import cds.gen.conferenceservice.Conferences;
import cds.gen.conferenceservice.Conferences_;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
@ServiceName("ConferenceService")
public class ConferenceServiceHandler implements EventHandler {

    private final NamedParameterJdbcTemplate jdbcTemplate;

    @Autowired
    public ConferenceServiceHandler(NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
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
