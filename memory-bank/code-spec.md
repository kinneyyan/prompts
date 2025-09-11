### **代码规约 Memory Bank**

本项目的代码规约基于 [@bud-fe/f2elint](https://www.npmjs.com/package/@bud-fe/f2elint)，它在飞冰的[代码质量保障](https://v2.ice.work/docs/guide/advanced/quality)方案上做了部分修改和扩展。

#### **1. JavaScript & TypeScript (ESLint)**

本项目的代码规范基于 `@iceworks/spec` 的 `react-ts` 配置，其核心是 `eslint-config-ali` 和 `@iceworks/eslint-plugin-best-practices`。

**核心规则摘要:**

- **代码风格**:
  - 缩进为 2 个空格。
  - 使用单引号。
  - 句末需要分号。
  - 行宽最大 120 字符。
  - 禁止不必要的空格和空行。
- **最佳实践**:
  - 使用严格相等 (`===`, `!==`)。
  - 禁止使用 `eval()` 和 `with`。
  - 禁止扩展原生对象。
  - `for-in` 循环需要有 `hasOwnProperty` 判断。
  - 禁止在 `return` 语句中赋值。
  - Promise 的 reject 需要传入 Error 对象。
- **React**:
  - 遵循 `eslint-plugin-react` 和 `eslint-plugin-jsx-a11y` 的推荐规则。
  - 推荐使用函数式组件。
- **TypeScript**:
  - 遵循 `@typescript-eslint/eslint-plugin` 的推荐规则。
  - 优先使用 `interface` 而不是 `type`（但在定义联合类型、交叉类型或工具类型时，推荐使用 `type`）。
  - 使用 `as` 进行类型断言。
  - 将重载的函数写在一起。
- **项目规范**:
  - 禁止使用 `http` url。
  - TS 项目中禁止出现 `.js` 文件。
  - 组件名使用大驼峰。

**本地覆盖规则:**

- `no-console`: 在生产环境中为 `warn`。
- `no-debugger`: 在生产环境中为 `warn`。
- `@iceworks/best-practices/recommend-functional-component`: `off`
- `no-return-assign`: `warn`
- `no-nested-ternary`: `warn`
- `no-case-declarations`: `warn`
- `no-fallthrough`: `warn`
- `tsdoc/syntax`: `warn`

#### **2. 样式 (Stylelint)**

样式规范基于 `stylelint-config-ali`。

**核心规则摘要:**

- **Possible Errors**:
  - 禁止无效的十六进制颜色。
  - 禁止空的注释。
  - 禁止重复的属性（允许不同值的连续重复）。
  - 禁止简写属性覆盖常规属性。
  - 禁止重复的字体族名。
  - 禁止未知的媒体特性名、属性、伪类、伪元素、单位。
- **代码风格**:
  - 缩进为 2 个空格。
  - 颜色使用小写十六进制，并尽可能缩写。
  - 禁止使用 ID 选择器。
  - 长度为 0 时省略单位。
- **LESS & SCSS**:
  - 项目已配置为同时支持 LESS 和 SCSS，并使用 `postcss-less` 和 `postcss-scss` 进行语法解析。
  - 禁止未知的 `@` 规则。

**本地覆盖规则:**

- `block-no-empty`: `null` (允许空代码块)

#### **3. 代码格式化 (Prettier)**

所有代码格式化遵循以下统一标准：

- **行宽 (`printWidth`)**: 每行最大宽度为 `120` 个字符。
- **引号 (`singleQuote`)**: 使用单引号 (`'`) 而不是双引号 (`"`).
- **分号 (`semi`)**: 句末必须使用分号。
- **缩进 (`tabWidth`, `useTabs`)**: 使用 `2` 个空格进行缩进，不使用 Tab。
- **尾随逗号 (`trailingComma`)**: 在多行对象和数组的末尾添加尾随逗号 (例如 `[1, 2, 3,]`)。
- **对象空格 (`bracketSpacing`)**: 对象字面量的大括号内侧需要有空格 (例如 `{ foo: bar }`)。
- **箭头函数括号 (`arrowParens`)**: 箭头函数的参数始终使用括号包裹 (例如 `(a) => a`)。
- **换行符 (`endOfLine`)**: 自动适应操作系统的换行符。

#### **4. Git Commit 规范**

项目集成了 `husky` 和 `lint-staged`，在每次 `git commit` 时会执行以下操作：

1.  **代码格式化**: 使用 `prettier` 格式化本次提交的代码。
2.  **ESLint 校验**: 对代码进行静态分析，发现潜在问题。
3.  **Stylelint 校验**: 检查样式代码是否符合规范。
4.  **Commit Message 校验**: 使用 `commitlint` 确保提交信息遵循 [Angular 规范](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)。

#### **5. 命名规范**

项目中的文件和目录名一律采用 `kebab-case`（短横线连接）的形式（例如 `login-wrapper`、`user-mgt`），而文件内部定义的 React 组件名应采用 `PascalCase`（大驼峰）的形式（例如 `UserMgt`）。
