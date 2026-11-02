---
draft: true
exam_objectives:
  - Observability
---
# Service Objectives, Budgets And Alerts

The `scout` service handles 100,000 eligible requests during a reporting window. A service-level indicator (SLI) is a measured service property, such as the fraction of successful requests. A service-level objective (SLO) sets a target for that indicator over a defined window. A service-level agreement (SLA) is an agreement that can attach consequences to service commitments.

If the SLO requires 99.9% successful requests, the allowed unsuccessful fraction is 0.1%. In this example, that permits 100 unsuccessful eligible requests. The error budget is the allowance implied by the objective. If 80 eligible requests have failed, 20 remain in the budget for that window. The arithmetic only makes sense after defining what counts as eligible and successful.

A request-based budget is different from a time-based availability budget. Ten minutes of outage can affect different numbers of requests depending on traffic. Do not replace one measure with another without checking the SLI definition. A latency objective likewise needs a threshold and an agreed measurement method.

Alerts should lead to useful action. A user-impacting symptom or fast error-budget consumption can justify urgent response. A minor resource fluctuation may justify investigation without waking an operator. Burn rate describes how quickly the service consumes its budget relative to the allowed rate; a high sustained rate predicts that the target is at risk.

Reliability objectives guide release decisions rather than requiring perfect uptime. A team can use budget consumption to balance change and stabilization according to its policy. The budget is not permission to ignore user failures; it is a defined way to reason about the chosen target.

A useful objective states the indicator, threshold, window and affected service. An actionable alert adds an owner and a response path. Without these definitions, an impressive percentage or dashboard does not provide a clear reliability contract.

## Calculating And Interpreting A Budget

For a request-based SLO of 99.9% success, multiply the eligible request count by 0.001 to obtain the allowed failures. One million eligible requests permit one thousand failures in the defined window. A service with eight hundred failures has consumed eighty percent of that allowance. This says nothing about the time remaining unless the window and expected traffic are also considered.

If the service consumes failures at ten times the allowed rate over a meaningful interval, its burn rate is high. A sustained high rate threatens to exhaust the budget much sooner than steady compliant behavior. Alert design often considers both short-term urgency and longer-term persistence so an isolated fluctuation does not behave like an ongoing outage.

The SLI definition must specify which requests count. Internal test traffic, intentionally rejected invalid requests and retries can affect interpretation if not classified consistently. A success response that produced incorrect data may not meet the business definition of success. Choose an indicator that approximates what users actually need.

## Targets And Agreements In Release Decisions

An SLO is an internal or shared target for a specified measurement window. An SLA can make contractual commitments with defined remedies or consequences. The agreement's measurement method may differ from the team's operational indicator, so do not assume every SLO breach automatically has the same contractual result.

A team can use budget consumption to decide whether to prioritize reliability work, reduce risky changes or continue ordinary releases. The policy should be defined before an incident. A budget is not a claim that failures are unimportant; it expresses the service level the team intends to sustain.

An alert should include a useful owner and action. A meaningful threshold with no responder or recovery path can still produce ineffective noise. Combine measured user impact, a clear target and a response contract so reliability numbers support decisions instead of merely decorating a dashboard.

## Common pitfalls

> [!WARNING]
> SLI, SLO and SLA describe measurement, target and agreement respectively. Request-based and time-based budgets are not interchangeable.
