package inside_payment.service;

import edu.fudan.common.util.Response;
import inside_payment.entity.AccountInfo;
import inside_payment.entity.Payment;
import inside_payment.entity.PaymentInfo;
import org.springframework.http.HttpHeaders;

/**
 * @author fdse
 */
public interface InsidePaymentService {

    Response pay(PaymentInfo info, HttpHeaders headers);

    Response createAccount(AccountInfo info, HttpHeaders headers);

    Response addMoney(String userId, String money, HttpHeaders headers);

    Response queryPayment(HttpHeaders headers);

    Response queryAccount(HttpHeaders headers);

    Response drawBack(String userId, String money, HttpHeaders headers);

    Response payDifference(PaymentInfo info, HttpHeaders headers);

    Response queryAddMoney(HttpHeaders headers);

    void initPayment(Payment payment, HttpHeaders headers);
}
