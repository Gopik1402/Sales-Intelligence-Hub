USE sales_management;
DELIMITER //

CREATE TRIGGER update_sales_after_payment
AFTER INSERT ON payment_splits
FOR EACH ROW
BEGIN
    UPDATE customer_sales
    SET received_amount = received_amount + NEW.amount_paid
    WHERE sale_id = NEW.sale_id;
    UPDATE customer_sales
    SET status = CASE WHEN (gross_sales - received_amount) <= 0 THEN 'Close' ELSE 'Open' END
    WHERE sale_id = NEW.sale_id;
END;
//

DELIMITER ;