# FakePay APP

## Request Example
```
 curl "localhost:3000/api/v1/subscriptions" \
  -X POST \
  -H "Content-Type: application/json" \
  -d \
  '{
    "subscription":
    {
      "customer_name": "Lucas Braathen",
      "address": "123 St",
      "zip_code": "10045",
      "product_id": 3,
      "card_number": "4242424242424242",
      "cvv": "123",
      "card_expiration_date": "2021-10-19",
      "billing_zip_code": "10045",
      "product_uuid": "99c74d44-08a1-43e0-bd6a-53dba636a876"
    }
  }'
  ```
