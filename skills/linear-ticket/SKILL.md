---
name: linear-ticket
description: Guide to the staged Linear workflow — linear-plan to write the execplan, then linear-build per milestone. For a single-shot fast path, use linear-ticket-yolo instead.
---

# Linear Ticket

This skill is a guide to the staged Linear workflow. Use the individual skills below:

## Staged Workflow (recommended)

1. **Plan**: `/linear-plan ENG-123`
   - Reads the ticket, asks clarifying questions, creates a plan branch, writes the execplan, comments on the ticket, moves to **Ready to Build**

2. **Optionally run a spike** if the approach is uncertain:
   - `/linear-spike ENG-123`
   - Exploratory throwaway run that documents surprises back into the plan, then resets all code

3. **Build each milestone**: `/linear-build ENG-123 [M1]`
   - One invocation per milestone — stacked branches, one PR per milestone
   - M1 moves the ticket to **In Progress**; the last milestone moves it to **Code Review**
   - Repeat for each milestone in order

## Fast Path (everything in one shot)

If the ticket is small or well-understood and you want a single PR with all changes:

`/linear-ticket-yolo ENG-123`
