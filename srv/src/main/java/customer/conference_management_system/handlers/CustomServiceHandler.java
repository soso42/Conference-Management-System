package customer.conference_management_system.handlers;

import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.ServiceName;
import org.springframework.stereotype.Component;
import cds.gen.my.cms.Conference;

@Component
@ServiceName("ConferenceService")
public class CustomServiceHandler implements EventHandler {

    @Before(event = { "CREATE", "UPDATE" }, entity = "ConferenceService.Conferences")
    public void beforeCreation(Conference conference) {

//        System.out.println("soso: event handler method was called.");

//        if (conference.getId() == null) {
//            conference.setId(null);
//        }
    }

}
