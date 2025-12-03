# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a frontend React template project based on ice.js 3, designed for console/H5 applications that can work as both micro-frontend child applications and standalone applications.

### Key Technologies

- Framework: ice.js 3 (React-based)
- Language: TypeScript
- Styling: Less with Ant Design v4
- State Management: ice.js store (based on [icestore](https://github.com/ice-lab/icestore))
- Routing: Convention-based routing
- HTTP Client: @bud-fe/request (axios wrapper)
- UI Components: Ant Design, @bud-fe/react-pc-ui, @ant-design/pro-components
- Testing: Vitest with Testing Library
- Linting: ESLint, Stylelint, Prettier with husky/lint-staged
- Package Manager: pnpm (v9.x)

## Common Development Commands

### Development

```bash
# Install dependencies
pnpm i

# Start development server
pnpm start

# Run tests
pnpm test

# Run tests with UI
pnpm test:ui

# Run linter
pnpm lint

# Run linter with auto-fix
pnpm lint:fix

# Format code with prettier
pnpm prettier
```

### Building

```bash
# Build for production
pnpm build

# Build for different environments
pnpm build:dev
pnpm build:test
pnpm build:uat
pnpm build:prod
pnpm build:hotfix
pnpm build:feature-1
pnpm build:feature-2
```

### Code Generation

```bash
# Generate code using plop templates
pnpm new
```

## Architecture Overview

### Project Structure

```
src/
├── app.tsx          # App configuration and data fetching
├── config.ts        # Environment-based configuration
├── constants/       # Global constants
├── pages/           # Page components (convention-based routing)
├── components/      # Reusable components
├── services/        # API service definitions
├── models/          # Global state models
├── store.ts         # Store configuration
├── utils/           # Utility functions
├── hooks/           # Custom hooks
├── menuConfig.tsx   # Menu configuration (for development)
├── global.less      # Global styles
└── styles/          # Style variables and mixins
```

### Core Concepts

1. **Routing**: Uses convention-based routing where files in `src/pages` automatically become routes
2. **State Management**: Uses ice.js store with model pattern for global state
3. **Authentication**: Custom auth implementation that works with backend permissions
4. **API Layer**: Centralized service layer in `src/services` using @bud-fe/request
5. **Micro-frontend**: Configured as an icestark child application by default
6. **Permissions**: Custom permission system based on backend-provided menu/button permissions
7. **Styling**: Uses Less with global variables and mixins, Ant Design components

### Data Flow

1. App initialization in `src/app.tsx` fetches user info and permissions
2. Permissions are used to control route access and button visibility
3. Global state is managed through ice.js store models
4. API calls are centralized in service files under `src/services`
5. Components consume data through props, store hooks, or direct service calls

### Testing

- Uses Vitest with Testing Library
- Test files are colocated with components in `__tests__` directories
- Mocks are used for service dependencies
- Component testing focuses on user interactions and UI behavior

## Key Implementation Patterns

### API Service Pattern

Services are centralized in `src/services` with typed interfaces for requests/responses. They use `@bud-fe/request` which is an axios wrapper with built-in features like token handling, request/response interceptors, and error handling.

### State Management Pattern

Uses ice.js store with model pattern:

- Models define initial state, reducers (synchronous updates), and effects (async operations)
- State is accessed through custom hooks
- Effects can dispatch other actions including async ones

### Permission System

- Permissions are fetched from backend on app initialization
- Route-level permissions are checked in layout components
- Button-level permissions use a custom `Auth` component wrapper
- Development mode shows all permissions by default

### Component Structure

- Components use CSS Modules with `.module.less` files
- Components are organized by feature/domain
- Reusable components are placed in `src/components`
- Page components are in `src/pages` following routing conventions

## Coding Standards

For detailed coding standards, please refer to the @./memory-bank/code-spec.md

## Unit Testing Guidelines

For detailed unit testing guidelines, please refer to the @./memory-bank/testing-spec.md.
