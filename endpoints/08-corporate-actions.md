# Corporate Actions

## GET /v2/corporate_actions/announcements — List Announcements

SDK: `client.get_corporate_announcements(filter=GetCorporateAnnouncementsRequest) -> List[CorporateActionAnnouncement]`

### Parameters (GetCorporateAnnouncementsRequest)
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `ca_types` | List[CorporateActionType] | Yes | DIVIDEND, MERGER, SPINOFF, SPLIT |
| `since` | date | Yes | Start date |
| `until` | date | Yes | End date |
| `symbol` | str | No | Filter by symbol |
| `cusip` | str | No | Filter by CUSIP |
| `date_type` | CorporateActionDateType | No | DECLARATION, EX, RECORD, PAYABLE |

### CorporateActionAnnouncement Fields
| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID | Announcement ID |
| `corporate_action_id` | str | Corporate action ID |
| `ca_type` | str | dividend, merger, spinoff, split |
| `ca_sub_type` | str | Subtype |
| `initiating_symbol` | str | Initiating symbol |
| `initiating_original_cusip` | str | Original CUSIP |
| `target_symbol` | str | Target symbol |
| `declaration_date` | date | Declaration date |
| `ex_date` | date | Ex-dividend date |
| `record_date` | date | Record date |
| `payable_date` | date | Payment date |
| `cash` | str | Cash amount |
| `old_rate` | str | Old rate |
| `new_rate` | str | New rate |

### Example
```python
from alpaca.trading.requests import GetCorporateAnnouncementsRequest
from alpaca.trading.enums import CorporateActionType
from datetime import date

announcements = client.get_corporate_announcements(
    filter=GetCorporateAnnouncementsRequest(
        ca_types=[CorporateActionType.DIVIDEND],
        since=date(2026, 1, 1),
        until=date(2026, 3, 1)))
```

## GET /v2/corporate_actions/announcements/{id} — Single Announcement

SDK: `client.get_corporate_announcement_by_id(corporate_announcment_id) -> CorporateActionAnnouncement`
