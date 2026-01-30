---
name: ice-js-3-development-patterns
description: Development patterns for ice.js 3 projects, covering page components (lists/forms), menu & permissions, API services, and state management. Use when creating or modifying pages, configuring routing/auth, or implementing data fetching in the ice.js 3 admin console.
---

# ice.js 3 Development Patterns

This skill provides standard architectural patterns and templates for developing in ice.js 3 admin console projects.

## 1. Page Components

Templates for standard UI pages using `@bud-fe/react-pc-ui` and Ant Design.

- **List Page:** Standard `BfFormTable` implementation with search and actions.
- **Form Page:** `FormView` architecture handling Add/Edit/View modes in a single component.

**Reference:** [Page Patterns](references/page-patterns.md)

## 2. API Services

Templates for encapsulating API logic.

- **Service Layer:** Standard patterns for `getList`, `getDetail`, and `add`, `update`.
- **Type Definitions:** strict TypeScript interfaces for API contracts.

**Reference:** [API Service Patterns](references/api-service.md)

## 3. Menu & Permissions (Project Specific)

_Refers to standard project conventions._

- **Menu:** Configure in `src/menuConfig.tsx`.
- **Permissions:** Use `AUTH_BTN_CODE` constants and wrap UI elements in `<Auth />`.

**Reference:** [Menu & Permissions](references/auth-menu.md)

## 4. State Management (Project Specific)

_Refers to standard project conventions._

- **Global State:** Use `src/models/*.ts` with `createModel`.
- **Usage:** Access via `store.useModel('modelName')`.

**Reference:** [State Management](references/state-management.md)

## 5. Mock Data Strategy

- **Trigger:** If the user does not mention backend API addresses, you MUST use mock data.
- **Location:** `mock/<domain>.ts` (e.g., `mock/product.ts` for product management).
- **Format:** Export a default object with keys as `METHOD /url`.

**Template:**

```typescript
export default {
  'GET /api/domain/list': {
    code: 200,
    data: {
      total: 20,
      records: Array.from({ length: 10 }).map((_, i) => ({
        id: i + 1,
        name: `Item ${i + 1}`,
        description: `Description for item ${i + 1}`,
        createTime: '2024-01-01',
      })),
    },
  },
  'POST /api/domain/add': {
    code: 200,
    data: true,
  },
};
```

## Workflow: Creating a New Feature

1.  **Define API & Mock Data**:
    - Create `src/services/<feature>/index.ts` using the **API Service Pattern**.
    - **[Conditional]** If API addresses are not provided, create `mock/<feature>.ts` using the **Mock Data Strategy**.
2.  **Scaffold Pages**:
    - Create a List Page using the **List Page Pattern**.
    - Create a `FormView` component using the **Form Page Pattern**.
    - Create wrapper pages (`add/index.tsx`, `edit/$id.tsx`, `detail/$id.tsx`) that use `FormView`.
3.  **Register Routes**: Add your pages to `src/pages/` (ice.js convention routing).
4.  **Register Menu**: Add entries to `src/menuConfig.tsx` and assign `AUTH_BTN_CODE`.
