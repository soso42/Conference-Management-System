package customer.conference_management_system.handlers;

import cds.gen.TicketType;
import cds.gen.Ticket_;
import cds.gen.attendeeservice.Attendees_;
import cds.gen.Attendee;
import cds.gen.Ticket;
import com.sap.cds.Result;
import com.sap.cds.Struct;
import com.sap.cds.services.cds.CqnService;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.persistence.PersistenceService;
import com.sap.cds.ql.Insert;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.*;

@Component
@ServiceName({ "AttendeeService" })
@RequiredArgsConstructor
public class AttendeeServiceHandler implements EventHandler {

    private final PersistenceService persistenceService;


    @Before(
            event = CqnService.EVENT_CREATE,
            entity = Attendees_.CDS_NAME
    )
    public void beforeCreation(Attendee attendee) {

        Ticket newTicket = Struct.create(Ticket.class);
        newTicket.setType(TicketType.REGULAR);
        newTicket.setPrice(123);
        newTicket.setConference(Map.of("ID", "22cbcaaa-af0c-4ecb-affb-27f487e85674"));

        // Persist the ticket directly using PersistenceService
        Result result = persistenceService.run(
                Insert.into(Ticket_.CDS_NAME).entry(newTicket)
        );
        Ticket savedTicket = result.first().get().as(Ticket.class);

        attendee.setTicket(savedTicket);
    }

}
