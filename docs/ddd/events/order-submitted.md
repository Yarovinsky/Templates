# Domain Event Sample — OrderSubmitted

> SAMPLE PATTERN: This event document is an example shape only.

## Event Meaning

`OrderSubmitted` records that an order crossed the aggregate boundary from draft to submitted and is ready for downstream processing.

## Payload Pattern

```json
{
  "eventId": "<uuid>",
  "occurredAt": "<iso-8601>",
  "orderId": "<order-id>",
  "submittedBy": "<actor-id>",
  "totalAmount": {
    "amount": "<decimal>",
    "currency": "<code>"
  }
}
```

## Related Artifacts

- Aggregate: [`docs/ddd/aggregates/order-aggregate.md`](docs/ddd/aggregates/order-aggregate.md)
- Workflow: [`docs/ddd/application-services/submit-order-application-service.md`](docs/ddd/application-services/submit-order-application-service.md)
