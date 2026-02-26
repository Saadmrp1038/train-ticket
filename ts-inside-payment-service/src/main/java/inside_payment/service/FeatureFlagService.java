package inside_payment.service;

import dev.openfeature.sdk.Client;
import dev.openfeature.sdk.OpenFeatureAPI;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;

@Service
public class FeatureFlagService {

    private Client client;

    @PostConstruct
    public void initialize() {
        try {
            this.client = OpenFeatureAPI.getInstance().getClient();
        } catch (Exception e) {
            // silently ignore
        }
    }

    public boolean isEnabled(String flagName) {
        try {
            if (client == null) {
                return false;
            }

            boolean isEnabled = client.getBooleanValue(flagName, false);
            return isEnabled;

        } catch (Exception e) {
            return false;
        }
    }
}
