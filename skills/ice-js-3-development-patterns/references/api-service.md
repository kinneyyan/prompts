# API Service Patterns

## 1. Directory Structure

**Convention:** `src/services/<domain>/<sub-domain>/`

```text
src/services/
  └── xx-mgt/
      ├── index.ts    // API methods
      └── types.ts    // Interfaces
```

## 2. Service Template (`index.ts`)

```typescript
import request from '@/utils/request';
import type { IAddEditXXParams, IXXDetailResp, IXXListItem, IXXListParams } from './types';

const xxMgtService = {
  /**
   * 获取xx分页列表
   */
  async getList(params: IXXListParams) {
    const res = await request.post<IPagingResp<IXXListItem>>('/api/domain/module/page', params).catch(() => null);
    return {
      // Note: Adapt fields based on backend (e.g., totalCount vs total, list vs records)
      total: res?.data?.total || 0,
      list: res?.data?.records || [],
    };
  },
  /**
   * 获取xx详情
   */
  getDetail(id: string) {
    return request.post<IXXDetailResp>('/api/domain/module/detail', { id });
  },
  /**
   * 新增xx
   */
  addXX(params: IAddEditXXParams) {
    return request.post('/api/domain/module/add', params);
  },
  /**
   * 更新xx
   */
  updateXX(params: IAddEditXXParams) {
    return request.post('/api/domain/module/update', params);
  },
};

export default xxMgtService;
```

## 3. Types Template (`types.ts`)

```typescript
/**
 * xx管理 - 分页列表入参
 */
export interface IXXListParams extends IPagingParams {
  name: string;
  orgCodes: string[][];
  // ... other fields
}

/**
 * xx管理 - 列表项
 */
export interface IXXListItem {
  id: string;
  name: string;
  // ... other fields
}

/**
 * xx管理 - 详情出参
 */
export interface IXXDetailResp {
  id: string;
  name: string;
  // ... other fields
}

/**
 * xx管理 - 新增/编辑入参
 */
export interface IAddEditXXParams {
  id?: string;
  name: string;
  // ... other fields
}
```
