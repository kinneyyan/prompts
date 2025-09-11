### **《单元测试编写规范》 (EARS 格式)**

#### **第一部分：测试组织与原则 (Test Organization & Principles)**

**REQ-TIPS-01: 测试文件创建维度 (Test File Creation Dimension)**

- **EARS Statement:** `Where the project uses a page-based routing architecture (e.g., ice3), the developer shall create unit test files organized according to the page routing dimension.`
- **Rationale:** This approach ensures that components are tested within the context of their actual usage. It also leverages the testing framework's (Vitest) capability to track the coverage of all imported components through these page-level tests, simplifying the test structure. To avoid naming conflicts for pages with the same name under different routes, the test file name should incorporate the full path.
- **Example:** For a page located at `/pages/user-mgt/index.tsx`, the test file shall be named `user-mgt.test.tsx`. For nested routes like `/pages/user-center/user-mgt/detail/$id.tsx`, the filename shall convert the full path to kebab-case while omitting dynamic segments (e.g., `user-center-user-mgt-detail.test.tsx`), following the pattern: `[full-route-path].test.[ext]`.

**REQ-TIPS-02: 测试文件存放位置 (Test File Location)**

- **EARS Statement:** `All unit test files SHALL be placed in the __tests__ directory at the project root level.`
- **Rationale:** Centralizing all test files in a single, dedicated directory at the root level improves project organization, makes it easier to locate and manage tests, and aligns with common testing practices in the frontend development community.
- **Example:** For any component or page being tested, its corresponding test file should be placed in the root `__tests__` directory following the naming convention specified in REQ-TIPS-01.

**REQ-TIPS-03: 独立组件测试的限制 (Limitation on Standalone Component Tests)**

- **EARS Statement:** `The developer shall not create separate unit test files for simple components that are consumed by a page, unless those components are complex, highly reusable, or have intricate logic that requires specific testing scenarios.`
- **Rationale:** To avoid test redundancy. The coverage for simple components is already tracked when the parent page's test suite is executed. However, complex or highly reusable components may warrant independent testing to ensure proper functionality across different usage contexts. A component is considered "complex" if it meets criteria such as: 1. Containing complex conditional rendering logic; 2. Being a "generic business component" reused across multiple pages.

**REQ-TIPS-04: 断言的必要性 (Mandatory Assertions)**

- **EARS Statement:** `While ensuring the unit test meets code coverage requirements, the developer shall guarantee that every test file contains meaningful assertions (e.g., using `expect`) to validate the component's behavior, state, and output.`
- **Rationale:** Code coverage metrics alone are insufficient as they only confirm that code has been executed, not that it behaved correctly. Assertions are essential for verifying the functional correctness of the software.

---

#### **第二部分：元素查询 (Element Querying)**

**REQ-TIPS-05: 优先使用测试库查询 (Prioritization of Testing Library Queries)**

- **EARS Statement:** `The developer shall use the query functions provided by the @testing-library/react package (e.g., getBy, queryBy, findBy) as the primary method for element selection in tests.`
- **Rationale:** Testing Library's queries encourage testing from a user's perspective, making tests more resilient to changes in the implementation details of components and improving overall test maintainability.

- **Note:** For detailed usage, refer to the official documentation: `https://testing-library.com/docs/queries/about`

**REQ-TIPS-06: 限制使用原生DOM API (Restricted Use of Native DOM APIs)**

- **EARS Statement:** `The developer shall only use native DOM query APIs (e.g., document.querySelector) for element selection if and only if selection via @testing-library/react queries is not feasible.`
- **Rationale:** Over-reliance on native DOM APIs can lead to brittle tests that break easily with minor refactoring of the component's internal structure.

**REQ-TIPS-07: 处理重复文本元素查询的最佳实践 (Best Practices for Handling Duplicate Text Element Queries)**

- **EARS Statement:** `When multiple elements on a page contain the same text content, the developer shall prioritize container-based queries using within() to ensure accurate element targeting, and may also use role-based queries or test-id attributes as alternatives.`
- **Rationale:** Prioritizing container-based queries with `within()` provides the most precise element selection while maintaining test readability and reliability. Role-based queries and test-ids are also effective alternatives when `within()` is not suitable. This approach ensures tests remain robust without sacrificing coverage.
- **Example:**

  ```typescript
  // Preferred approach: Use within() for container-based queries
  expect(within(screen.getByRole('table')).getByText('ID')).toBeInTheDocument();

  // Alternative 1: Use role-based queries
  expect(screen.getByRole('columnheader', { name: 'ID' })).toBeInTheDocument();

  // Alternative 2: Use test-id attributes when available
  expect(screen.getByTestId('table-column-id')).toBeInTheDocument();
  ```

**REQ-TIPS-08: 处理Select组件重复元素查询 (Handling Select Component Duplicate Element Queries)**

- **EARS Statement:** `When testing antd Select components and multiple elements share the same title/text content (e.g., selected item display and dropdown options), the developer shall use role-based queries or more specific selectors to target the dropdown option element.`
- **Rationale:** Select components often render the same text in both the selection display and dropdown options, causing query conflicts. Using specific selectors ensures accurate element targeting for interaction testing.
- **Example:**

  ```typescript
  // For select dropdown options:
  fireEvent.mouseDown(screen.getByLabelText('性别'));

  // Option 1: Use role-based query (recommended)
  fireEvent.click(screen.getByRole('option', { name: '男' }));

  // Option 2: Use more specific selector
  fireEvent.click(screen.getByText('男').closest('.ant-select-item-option'));

  // Option 3: Use within with dropdown container
  const dropdown = screen.getByRole('listbox'); // antd select dropdown
  fireEvent.click(within(dropdown).getByText('男'));
  ```

**REQ-TIPS-9: antd `Button` 中文内容查询 (Querying antd `Button` with Chinese Text)**

- **EARS Statement:** `When querying an antd Button component, if and only if the button's label consists of exactly two Chinese characters, the developer shall insert a space between the characters in the query text, unless the button's type is "link".`
- **Rationale:** The antd `Button` component automatically inserts a space between a two-character Chinese label for aesthetic reasons on its default, primary, dashed, and text types. This behavior is strictly limited to two-character labels and does not apply to buttons with other label lengths (e.g., one or three characters) or those with `type="link"`. Failing to account for this distinction will result in a `TestingLibraryElementError`.
- **Example:**

  ```typescript
  // Correct: Two-character button requires a space
  // For: <Button>新增</Button>
  screen.getByRole('button', { name: '新 增' });

  // Correct: Two-character primary button requires a space
  // For: <Button type="primary">导出</Button>
  screen.getByRole('button', { name: '导 出' });

  // Correct: Link-type button does not require a space
  // For: <Button type="link">查看</Button>
  screen.getByRole('button', { name: '查看' });

  // Correct: Non-two-character button does not require a space
  // For: <Button>新增售点</Button>
  screen.getByRole('button', { name: '新增售点' });
  ```

**REQ-TIPS-10: 表格操作按钮中文内容查询 (Querying Table Action Buttons with Chinese Text)**

- **EARS Statement:** `When querying action buttons within table components (e.g., BfFormTable), the developer shall use the exact text label as defined in the component configuration without adding spaces.`
- **Rationale:** Action buttons within `BfFormTable` are typically implemented as antd `Button` components with `type="link"`. As specified in REQ-TIPS-09, link-type buttons—regardless of the number of characters in their label—do not have spaces automatically inserted. Therefore, querying should always use the exact label text.
- **Example:**

  ```typescript
  // For a two-character table action button: { action: 'edit', label: '编辑' }
  screen.getByRole('button', { name: '编辑' }); // No spaces because it's a link-type button

  // For a three-character table action button: { action: 'delete', label: '删除行' }
  screen.getByRole('button', { name: '删除行' }); // No spaces
  ```

---

#### **第三部分：事件模拟 (Event Simulation)**

**REQ-TIPS-11: 交互模拟标准 (Interaction Simulation Standard)**

- **EARS Statement:** `The developer shall use @testing-library/react's fireEvent for basic DOM event simulation, and @testing-library/user-event for more realistic user interaction simulation.`
- **Rationale:** Both libraries serve different purposes in testing. `fireEvent` is sufficient for triggering basic DOM events directly. However, for more realistic user interactions, `user-event` should be preferred as it simulates the complete user interaction process, not just individual DOM events. `user-event` dispatches the full sequence of events that a real user would trigger (e.g., hover, focus, click), leading to more robust and reliable tests.

**REQ-TIPS-12: 禁止冗余的`act()`调用 (Prohibition of Redundant `act()` Wrapping)**

- **EARS Statement:** `The developer shall not manually wrap APIs from @testing-library/react (e.g., render, fireEvent) or calls from @testing-library/user-event within the act() utility.`
- **Rationale:** These specific testing library functions are already wrapped in `act()` internally. Redundant wrapping adds unnecessary complexity and can obscure test logic. For handling asynchronous updates, see REQ-TIPS-13.

**REQ-TIPS-13: 异步操作的等待策略 (Waiting Strategy for Asynchronous Operations)**

- **EARS Statement:** `When testing asynchronous operations (e.g., UI updates after an API call, or asserting that a mock function has been called), the developer shall use `findBy\*`queries or the`waitFor` utility to await the completion of these operations before making assertions.`
- **Rationale:** `findBy*` and `waitFor` are the idiomatic and most reliable ways to handle asynchronous operations in @testing-library/react. They poll the DOM until a condition is met or a timeout occurs, making tests more robust and less flaky. This applies to waiting for UI elements to appear and for asserting that asynchronous function calls have occurred.
- **Example:**

  ```typescript
  // 场景1: 等待 UI 元素出现
  expect(await screen.findByText('Loaded Content')).toBeInTheDocument();

  // 场景2: 等待异步函数调用
  fireEvent.click(screen.getByText('查 询'));
  await waitFor(() => {
    expect(mockService.fetchData).toHaveBeenCalledWith({ query: 'test' });
  });
  ```

**REQ-TIPS-14: antd `Input`/`TextArea` 交互 (Interacting with antd `Input`/`TextArea`)**

- **EARS Statement:** `When testing antd Input or TextArea components, the developer shall simulate value changes using fireEvent.change.`
- **Rationale:** This is the standard method for simulating change events on input-like elements.
- **Example:**
  ```typescript
  fireEvent.change(screen.getByLabelText('姓名'), { target: { value: '张三' } });
  ```

**REQ-TIPS-15: antd `Select`/`Cascader` 交互 (Interacting with antd `Select`/`Cascader`)**

- **EARS Statement:** `When testing antd Select or Cascader components, the developer shall simulate the selection process by first triggering fireEvent.mouseDown on the component, and then triggering fireEvent.click on the desired option element.`
- **Rationale:** These components' dropdowns are typically triggered by a `mouseDown` event. The subsequent choice is a `click` event.
- **Example:**
  ```typescript
  fireEvent.mouseDown(screen.getByLabelText('性别'));
  fireEvent.click(screen.getByTitle('男'));
  ```

**REQ-TIPS-16: antd `DatePicker` 交互 (Interacting with antd `DatePicker`)**

- **EARS Statement:** `When testing an antd DatePicker component, the developer shall simulate date selection through a sequence of events: first `mouseDown`on the input, then a`change`event to set the text value, and finally a`click` on the selected date cell in the calendar popover.`
- **Rationale:** This multi-step process accurately simulates the complex interaction required to select a date in the `DatePicker` component. While `@testing-library/react` queries are preferred, the `DatePicker`'s popover DOM structure can sometimes make it difficult to reliably target a specific date cell. In such exceptional cases, a more specific selector may be necessary.
- **Example:**
  ```typescript
  const dateInput = screen.getByLabelText('入职日期');
  fireEvent.mouseDown(dateInput);
  fireEvent.change(dateInput, { target: { value: '2024-01-01' } });
  // Preferred method:
  fireEvent.click(screen.getByRole('cell', { name: '1' }).closest('td[title="2024-01-01"]'));
  // Fallback (if preferred method fails due to complex DOM):
  // fireEvent.click(document.querySelector('[title="2024-01-01"].ant-picker-cell-selected'));
  ```

**REQ-TIPS-17: antd `Pagination` 交互 (Interacting with antd `Pagination`)**

- **EARS Statement:** `When testing antd Pagination components, the developer shall use within() queries with specific CSS selectors to target pagination elements within the pagination container.`
- **Rationale:** Pagination components often have multiple elements with similar attributes. Using container-based queries ensures accurate element targeting and prevents conflicts with other elements on the page.
- **Example:**

  ```typescript
  // Preferred method: Use within() to scope the query
  const pagination = screen.getByRole('navigation'); // The antd pagination container has role="navigation"
  const pageButton = within(pagination).getByText('2');
  fireEvent.click(pageButton);

  // Alternative approach using screen.getByTitle (less robust if titles are duplicated elsewhere):
  // const pageButton = await screen.findByTitle('2');
  // fireEvent.click(pageButton);
  ```

---

#### **第四部分：模拟 (Mocking)**

**REQ-TIPS-18: `setTimeout` 模拟 (`setTimeout` Mocking)**

- **EARS Statement:** `When testing asynchronous code involving timers (e.g., setTimeout) within an ice3 project, the developer shall use Vitest's fake timers in conjunction with a @testing-library/user-event setup configured to advance timers.`
- **Rationale:** Due to known issues in the `ice3` environment, standard timer mocks may be unreliable. This specific configuration ensures that timers are advanced correctly and consistently during tests.
- **Example:**

  ```typescript
  // In test setup:
  beforeEach(() => {
    vi.useFakeTimers({ shouldAdvanceTime: true });
  });
  afterEach(() => {
    vi.useRealTimers();
  });
  const user = userEvent.setup({ advanceTimers: vi.advanceTimersByTime });

  // In test case:
  await user.click(screen.getByRole('button', { name: '完 成' }));
  await act(() => vi.runAllTimers());
  ```

**REQ-TIPS-19: ice 模块模拟规范 (ice Module Mocking Standard)**

- **EARS Statement:** `当需要模拟 ice 模块中的函数或对象时，开发者必须首先检查 __mocks__/ice.mjs 文件中是否已存在全局模拟实现，只有当测试有特殊需求且全局模拟无法满足时，才允许在测试文件中使用 vi.spyOn 进行特定模拟。`
- **Rationale:** 这种分层模拟策略确保了测试的一致性和可维护性。全局模拟（**mocks**/ice.mjs）处理通用场景，避免重复代码；而特定模拟（vi.spyOn）仅用于处理测试专用场景。这种优先级机制既保证了测试的隔离性，又避免了模拟冲突和维护困难。特定模拟仅在以下情况下被视为必需：1. 测试需要与全局模拟不同的特定响应；2. 测试需要断言函数调用的详细信息（如参数、调用次数），而这些信息在其他测试中不相关。
- **Example:**

  ```typescript
  import * as ice from 'ice';

  // 场景1: 模拟 ice 模块的 useSearchParams 函数
  vi.spyOn(ice, 'useSearchParams').mockImplementation(() => {
    return [new URLSearchParams({ activityCode: 'CRM20250326M000002' })] as any;
  });

  // 场景2: 模拟 ice 模块的 useParams 函数
  vi.spyOn(ice, 'useParams').mockReturnValue({ id: '1' });
  ```

**REQ-TIPS-20: 通用API请求模拟 (Mocking Common API Requests)**

- **EARS Statement:** `For common API endpoints that are shared across multiple test suites (e.g., fetching global enums), the developer shall define the mock response in a central mock file (e.g., __mocks__/api.mjs).`
- **Rationale:** Centralizing common mocks promotes reusability and DRY (Don't Repeat Yourself) principles, making the test suite easier to maintain.

**REQ-TIPS-21: 特定API请求模拟 (Mocking Specific API Requests)**

- **EARS Statement:** `For API requests that are specific to a single test suite or test case, the developer shall use vi.spyOn to mock the corresponding service function directly within that test file.`
- **Rationale:** This keeps test-case-specific logic contained within the relevant test, improving clarity and preventing global mock files from becoming bloated with scenario-specific data.
- **Example:**
  ```typescript
  import demoService from '@/services/demo';
  vi.spyOn(demoService, 'getUserList').mockResolvedValue({ total: 0, list: [] });
  ```

**REQ-TIPS-22: API请求模拟规范 (API Request Mocking Standard)**

- **EARS Statement:** `The developer shall not use `vi.mock` for API request mocking; instead, the developer shall strictly follow the mocking strategies defined in REQ-TIPS-20 and REQ-TIPS-21.`
- **Rationale:** Using `vi.mock` for API mocking can lead to unintended global side effects and test contamination across suites. `vi.mock` is hoisted to the top of the file, making its scope broad and potentially leaky across test files, which can cause intermittent failures. In contrast, `vi.spyOn` offers more precise, controllable scoping that can be easily managed within `beforeEach`/`afterEach` blocks, ensuring better test isolation. Therefore, adhering to REQ-TIPS-20 and REQ-TIPS-21 is mandatory.
- **Example:**

  ```typescript
  // 正确做法：遵循 REQ-TIPS-21
  import userService from '@/services/user';
  vi.spyOn(userService, 'getUserList').mockResolvedValue({ data: [] });

  // 禁止做法：使用 vi.mock
  // vi.mock('@/services/user', () => ({
  //   getUserList: vi.fn().mockResolvedValue({ data: [] })
  // }));
  ```
