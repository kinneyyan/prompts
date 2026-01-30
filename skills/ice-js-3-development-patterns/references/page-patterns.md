# Page Component Patterns

## 1. List Page Pattern

### File Structure

`src/pages/<module>/<sub-module>/index.tsx`

### Key Principles

- Use `BfFormTable` from `@bud-fe/react-pc-ui` for consistency.
- Decouple Actions, Search, and Table configuration.

A standard example of a list page using `BfFormTable`:

```tsx
import Auth from '@/components/auth';
import PageHeader from '@/components/page-header';
import { AUTH_BTN_CODE, SUCCESS_CODE } from '@/constants';
import commonService from '@/services/common';
import xxMgtService from '@/services/xx-mgt';
import { BfFormTable } from '@bud-fe/react-pc-ui';
import { transferMapToOptions } from '@bud-fe/utils';
import { Button, message, Modal, Tooltip } from 'antd';
import { history } from 'ice';

const ENUM_ITEM_STATUS = { ENABLED: 1, DISENABLED: 0 };

const MAP_ITEM_STATUS = {
  [ENUM_ITEM_STATUS.ENABLED]: '启用',
  [ENUM_ITEM_STATUS.DISENABLED]: '停用',
};

export default function StandardListPage() {
  // 1. Action Column definition
  const actionsColumn = BfFormTable.useActionsColumn({
    AuthWrapperComp: Auth,
    items: (record) => [
      { action: 'view', label: '查看', authKey: AUTH_BTN_CODE.module.view },
      { action: 'edit', label: '编辑', authKey: AUTH_BTN_CODE.module.edit },
      {
        action: 'disable',
        label: '停用',
        authKey: AUTH_BTN_CODE.module.enableDisable,
        visible: record.status === ENUM_ITEM_STATUS.ENABLED,
      },
      {
        action: 'enable',
        label: '启用',
        authKey: AUTH_BTN_CODE.module.enableDisable,
        visible: record.status === ENUM_ITEM_STATUS.DISENABLED,
      },
    ],
    onActionBtnClick(item, record) {
      switch (item.action) {
        case 'view':
          history?.push(`/path/detail/${record.id}`);
          break;
        case 'edit':
          history?.push(`/path/edit/${record.id}`);
          break;
        case 'enable':
          Modal.confirm({
            title: '启用',
            content: `确认启用 ${record.name} ？`,
            onOk: () => {
              handleBatchEnableOrDisable(true, [record.id]);
            },
          });
          break;
        case 'disable':
          Modal.confirm({
            title: '停用',
            content: `确认停用 ${record.name} ？`,
            onOk: () => {
              handleBatchEnableOrDisable(false, [record.id]);
            },
          });
          break;
        default:
          break;
      }
    },
  });

  // 2. FormTable Hook
  const { tableProps, search, form, refresh, selectedRowKeys, setSelectedRowKeys } = BfFormTable.useFormTable({
    cacheKey: 'xx-mgt',
    service: xxMgtService.getList,
    pagingParamsFormatter: ({ current, pageSize }) => ({ pageNum: current, pageSize }),
    searchFormItems: [
      { type: 'input', name: 'name', label: '名称' },
      // 枚举从前端本地、单选
      {
        type: 'select',
        name: 'status',
        label: '状态',
        fieldProps: {
          allowClear: true,
          options: transferMapToOptions(MAP_ITEM_STATUS),
        },
      },
      // 枚举从远程接口、多选
      {
        type: 'select',
        name: 'type',
        label: '类型',
        request: xxMgtService.getTypeEnum,
        fieldProps: { mode: 'multiple' },
      },
      // 级联选择
      {
        type: 'cascader',
        name: 'orgCodeList',
        label: '组织架构',
        fieldProps: {
          multiple: true,
          showArrow: true,
          showSearch: true,
          maxTagCount: 1,
          fieldNames: { label: 'name', value: 'code', children: 'subList' },
        },
        request: commonService.getOrgTree,
      },
    ],
    tableColumns: [
      { title: 'ID', dataIndex: 'id' },
      { title: '名称', dataIndex: 'name' },
      { title: '状态', dataIndex: 'status', render: (v) => MAP_ITEM_STATUS[v] },
      { title: '类型', dataIndex: 'typeName' },
      {
        title: '组织架构',
        dataIndex: 'orgInfoList',
        render: (_, record) => {
          return (
            <Tooltip
              overlayInnerStyle={{ width: 'max-content' }}
              title={record.orgInfoList?.map((it, idx) => (
                <div key={idx}>{it.orgNameList.join('-')}</div>
              ))}
            >
              {record.orgInfoList?.length > 1
                ? `${record.orgInfoList?.[0]?.orgNameList.join('-')}...`
                : record.orgInfoList?.[0]?.orgNameList.join('-') || '-'}
            </Tooltip>
          );
        },
      },
      actionsColumn,
    ],
  });

  const handleBatchEnableOrDisable = async (enableOrDisable: boolean, ids: string[]) => {
    const actionPromise = enableOrDisable ? xxMgtService.enable(ids) : xxMgtService.disable(ids);
    const res = await actionPromise.catch(() => null);
    if (SUCCESS_CODE === res?.code) {
      message.success('操作成功');
      setSelectedRowKeys([]);
      refresh();
    }
  };

  const actionBar = [
    <Button
      type="ghost"
      disabled={!selectedRowKeys.length}
      onClick={() => {
        handleBatchEnableOrDisable(true, selectedRowKeys as string[]);
      }}
    >
      批量启用
    </Button>,
    <Button
      type="ghost"
      disabled={!selectedRowKeys.length}
      onClick={() => {
        handleBatchEnableOrDisable(false, selectedRowKeys as string[]);
      }}
    >
      批量停用
    </Button>,
    <Auth authKey={AUTH_BTN_CODE.module.add}>
      <Button type="primary" onClick={() => history?.push('/path/add')}>
        新增
      </Button>
    </Auth>,
  ];

  return (
    <>
      <PageHeader title="xx管理" />
      <BfFormTable
        rowKey="id"
        actionBarTitle="xx管理列表"
        actionBar={actionBar}
        search={search}
        form={form}
        {...tableProps}
      />
    </>
  );
}
```

- Use WebFetch to retrieve the latest guidelines of `BfFormTable` component: `https://react-pc-ui.pages.dev/docs/components/form-table`

## 2. Form Page Pattern (Detail/Add/Edit)

A `FormView` component is shared by the add, edit, and detail pages.

## File Structure

```text
xx-mgt/
├── add
│   └── index.tsx
├── components
│   └── form-view
│       └── index.tsx
├── detail
│   └── $id.tsx
├── edit
│   └── $id.tsx
└── index.tsx    // list page
```

A standard example of a `FormView` component:

```tsx
import { SUCCESS_CODE } from '@/constants';
import commonService from '@/services/common';
import xxMgtService, { IAddEditXXParams } from '@/services/xx-mgt';
import { ProCard, ProForm, ProFormCascader, ProFormSelect, ProFormText } from '@ant-design/pro-components';
import { Form, message } from 'antd';
import { history, useParams } from 'ice';
import { isNil } from 'lodash-es';

interface IFormData {
  id: string;
  name: string;
  type: number[];
  orgCodes: string[][];
}

export default function FormView({ mode }: { mode: 'add' | 'edit' | 'view' }) {
  const params = useParams<{ id?: string }>();
  const readonly = mode === 'view';
  const isEdit = mode === 'edit' && !!params.id;
  const [form] = Form.useForm<IFormData>();

  const requestDetail = async ({ id }) => {
    if (isNil(id)) {
      return {};
    }
    const res = await xxMgtService.getDetail(id).catch(() => null);
    const { name, type, ...restData } = res?.data || {};
    // handle the conversion of the data structure from the interface to the form if necessary
    const formData: IFormData = { id, name, type, ...restData };
    return formData;
  };

  const goBack = () => history?.go(-1);

  const handleFinish = async (values: IFormData) => {
    const { name, type, ...restValues } = values;
    // handle the conversion of the data structure from the form to the interface if necessary
    const requestParams: IAddEditXXParams = { name, type, ...restValues };
    const submitPromise = isEdit
      ? xxMgtService.edit({ id: params.id, requestParams })
      : xxMgtService.add(requestParams);
    const res = await submitPromise.catch(() => null);
    if (SUCCESS_CODE === res?.code) {
      message.success('提交成功', 0.5, goBack);
    }
  };

  return (
    <ProCard>
      <ProForm<IFormData | {}>
        form={form}
        readonly={readonly}
        params={{ id: params.id }}
        request={requestDetail}
        onFinish={handleFinish}
        onReset={goBack}
        submitter={{
          searchConfig: { resetText: readonly ? '返回' : '取消' },
          submitButtonProps: readonly ? { style: { display: 'none' } } : undefined,
        }}
      >
        <ProFormText label="ID" name="id" readonly hidden={mode === 'add'} />
        <ProFormText
          name="name"
          label="名称"
          width="lg"
          fieldProps={{ maxLength: 20 }}
          required={!readonly}
          rules={[{ required: true }]}
        />
        <ProFormSelect
          name="type"
          label="类型"
          width="lg"
          mode="multiple"
          request={xxMgtService.getTypeEnum}
          required={!readonly}
          rules={[{ required: true }]}
        />
        <ProFormCascader
          name="orgCodes"
          label="组织架构"
          width="lg"
          fieldProps={{
            multiple: true,
            showArrow: true,
            showSearch: true,
            fieldNames: { label: 'name', value: 'code', children: 'subList' },
          }}
          request={commonService.getOrgTree}
          required={!readonly}
          rules={[{ required: true }]}
        />
      </ProForm>
    </ProCard>
  );
}
```
