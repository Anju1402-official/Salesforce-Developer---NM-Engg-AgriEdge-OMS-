# AgriEdge OMS Salesforce Project

This repository contains a Salesforce DX implementation of the AgriEdge Or-Mange Ltd Order Management System (OMS).

## Included

- Custom objects for orders, order items, inventory, and shipments
- Formula fields and validation rules from the project brief
- A Lightning app and custom tabs
- A record-triggered flow to automate follow-up task creation for new orders
- Apex automation to keep order totals and inventory in sync
- Apex test coverage
- A permission set for AgriEdge OMS users

## Project Structure

- `force-app/main/default/objects` - Custom objects, fields, and validation rules
- `force-app/main/default/classes` - Apex classes, trigger, and tests
- `force-app/main/default/flows` - Order automation flow
- `force-app/main/default/applications` - Lightning app
- `force-app/main/default/tabs` - Custom tabs
- `force-app/main/default/permissionsets` - Access bundle for admins and demo users

## Deployment

1. Install Salesforce CLI.
2. Authorize your org:

```bash
sf org login web --alias AgriEdgeDev
```

3. Deploy metadata:

```bash
sf project deploy start --target-org AgriEdgeDev
```

4. Run tests:

```bash
sf apex run test --target-org AgriEdgeDev --test-level RunLocalTests
```

## Notes

- The brief references Process Builder. Salesforce now recommends Flow, so this project uses a record-triggered Flow for the same automation outcome.
- The shipment object lookup is implemented against `AgriEdge_Order__c`, which matches the rest of the custom OMS model.

## GitHub

The local repository folder name matches the requested GitHub repository:

`Salesforce-Developer---NM-Engg-AgriEdge-OMS-`

If you want to publish it manually after review:

```bash
git init
git add .
git commit -m "Add AgriEdge OMS Salesforce DX project"
git branch -M main
git remote add origin https://github.com/Anju1402-official/Salesforce-Developer---NM-Engg-AgriEdge-OMS-.git
git push -u origin main
```
