import Mock from 'mockjs';
import qs from 'query-string';
import setupMock, { successResponseWrap } from '@/utils/setup-mock';
import { GetParams } from '@/types/global';

const { Random } = Mock;

const roles = [
  {
    id: 1,
    name: '项目工程师',
  },
  {
    id: 2,
    name: '项目主管',
  },
  {
    id: 3,
    name: '项目经理',
  },
];

const data = Mock.mock({
  'list|55': [
    {
      'id|4': /[0-9]/,
      'username|4-8': /[a-z]/,
      'password|4-8': /[a-z]/,
      'name|4-8': /[A-Z]/,
      'admin|1': [true, false],
      'roles': [roles[Math.floor(Math.random() * 2)]],
      'createdTime': Random.datetime(),
    },
  ],
});

setupMock({
  setup() {
    Mock.mock(new RegExp('/api/users'), (params: GetParams) => {
      const { current = 1, pageSize = 10 } = qs.parseUrl(params.url).query;
      const p = current as number;
      const ps = pageSize as number;
      return successResponseWrap({
        list: data.list.slice((p - 1) * ps, p * ps),
        total: 55,
      });
    });
  },
});
