package contacts.service;

import dev.openfeature.sdk.Client;
import dev.openfeature.sdk.FlagEvaluationDetails;
import dev.openfeature.sdk.OpenFeatureAPI;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;

@Service
public class FeatureFlagService {

    private Client client;
    private boolean isInitialized = false;

    @PostConstruct
    public void initialize() {
        try {
            // Get a named client for contacts-service
            this.client = OpenFeatureAPI.getInstance().getClient("contacts-service");
            this.isInitialized = true;
        } catch (Exception e) {
            // silently ignore
        }
    }

    public boolean isEnabled(String flagName) {
        // Simple fix: If not initialized yet, return false (safe default)
        if (!this.isInitialized || this.client == null) {
            return false;
        }

        try {
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
