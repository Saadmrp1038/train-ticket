package cancel.service;

import dev.openfeature.sdk.Client;
import dev.openfeature.sdk.FlagEvaluationDetails;
import dev.openfeature.sdk.OpenFeatureAPI;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;

@Service
public class FeatureFlagService {

    private Client client;

    @PostConstruct
    public void initialize() {
        try {
            // Get a named client for cancel-service (like Python version uses "voucher-service")
            this.client = OpenFeatureAPI.getInstance().getClient("cancel-service");
        } catch (Exception e) {
            // silently ignore
        }
    }

    public boolean isEnabled(String flagName) {
        try {
            if (client == null) {
                return false;
            }

            // Use getBooleanDetails to get detailed information (like Python version)
            FlagEvaluationDetails<Boolean> details = client.getBooleanDetails(flagName, false);

            if ("ERROR".equals(details.getReason())) {
                return false;
            }

            return Boolean.TRUE.equals(details.getValue());

        } catch (Exception e) {
            return false;
        }
    }
}
