# State Management Patterns

## 1. Global State

**Reference:** `src/models/user.ts`

**Key Pattern:**

- Use `ice` framework's `createModel`.
- State models are placed in `src/models/`.
- Models have `state`, `reducers` (sync), and `effects` (async).

**Structure:**

```typescript
import { createModel } from 'ice';

interface IUserState {
  userInfo: any;
}

export default createModel({
  state: {
    userInfo: null,
  } as IUserState,

  reducers: {
    updateUserInfo(prevState, payload) {
      return { ...prevState, userInfo: payload };
    },
  },

  effects: (dispatch) => ({
    async fetchUserInfo() {
      const data = await userService.getUserInfo();
      dispatch.user.updateUserInfo(data);
    },
  }),
});
```

## 2. Consuming State

**Reference:** `src/components/right-header-menu/user/index.tsx`

**Key Pattern:**

- Use `store.useModel('modelName')` hook.
- Returns tuple: `[state, dispatchers]`.

**Usage:**

```typescript
import store from '@/store';

export default function UserProfile() {
  const [userState, userDispatchers] = store.useModel('user');
  const { userInfo } = userState;

  const handleLogout = () => {
    userDispatchers.logout();
  };

  return <div>{userInfo?.name}</div>;
}
```
