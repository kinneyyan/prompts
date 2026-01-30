# Menu & Permissions Patterns

## 1. Menu Configuration

**Reference:** `src/menuConfig.tsx`

**Structure:**
The menu is defined as an array of `TMenuDataItem`.
Each item can have:

- `name`: Display name.
- `path`: Route path.
- `icon`: Ant Design icon component.
- `children`: Nested menu items.
- `hideChildrenInMenu`: Boolean to hide sub-menus (useful for flat pages like detail/edit under a list).
- `btnCode`: Button permission code (from `AUTH_BTN_CODE`).

**Example:**

```tsx
import { AUTH_BTN_CODE } from '@/constants';
import { SettingOutlined } from '@ant-design/icons';

const asideMenuConfig = [
  {
    name: 'Activity Management',
    path: '/marketing-activity-mgt',
    icon: SettingOutlined,
    children: [
      {
        name: 'Auto Marketing',
        path: '/marketing-activity-mgt/auto-marketing',
        hideChildrenInMenu: true,
        children: [
          {
            name: 'Add',
            path: '/marketing-activity-mgt/auto-marketing/add',
            btnCode: AUTH_BTN_CODE.marketingActivityMgt.activityMgt.add,
          },
          // ...
        ],
      },
    ],
  },
];
```

## 2. Button Permissions

**Reference:** `src/components/auth/index.tsx`

**Key Pattern:**
Wrap components that require permission in the `<Auth>` component.
In development (`config.env === 'development'`), permissions are often bypassed.

**Usage:**

```tsx
import Auth from '@/components/auth';
import { AUTH_BTN_CODE } from '@/constants';

<Auth authKey={AUTH_BTN_CODE.someModule.add}>
  <Button>Add Item</Button>
</Auth>;
```

**Fallback:**
You can provide a fallback UI if the user lacks permission.

```tsx
<Auth authKey={AUTH_BTN_CODE.view} fallback={<span>(Hidden)</span>}>
  <Link to="...">View Detail</Link>
</Auth>
```
