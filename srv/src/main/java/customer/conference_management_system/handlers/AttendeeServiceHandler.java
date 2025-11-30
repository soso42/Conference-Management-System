package customer.conference_management_system.handlers;

import cds.gen.Attendee;
import cds.gen.attendeeservice.Attendees_;
import com.sap.cds.services.cds.CqnService;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.ServiceName;
import org.springframework.stereotype.Component;

@Component
@ServiceName("AttendeeService")
public class AttendeeServiceHandler implements EventHandler {

    @Before(
            event = CqnService.EVENT_CREATE,
            entity = Attendees_.CDS_NAME
    )
    public void beforeCreation(Attendee attendee) {

    }

}
