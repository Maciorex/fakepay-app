# FakePay APP

Fakepay coding challenge app.

## Requirements
- create api for subscription creation
- one customer can have multiple subscriptions
- create a code that could be used for re-charging subscriptions

## Setup

You need a `master.key` to be able to get to secrets.
To set up db just run `docker-compose up` and `rails db:seed` to populate products in DB.

## API paramaters
<table>
  <tr>
    <td><strong>Name</strong></td>
    <td><strong>Type</strong></td>
    <td><strong>Description</strong></td>
  </tr>
</table>

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
      "card_number": "4242424242424242",
      "cvv": "123",
      "card_expiration_date": "10/2021",
      "billing_zip_code": "10045",
      "product_uuid": "99c74d44-08a1-43e0-bd6a-53dba636a876"
      "months_valid": 5
    }
  }'
  ```
