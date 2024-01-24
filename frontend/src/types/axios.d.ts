import { AxiosResponse } from 'axios';

export interface Pagination {
  total: number;
  per_page: number;
  page: number;
  total_pages: number;
}

export interface Meta {
  pagination?: Pagination;
}

declare module 'axios' {
  interface AxiosResponse<T = any> extends Promise<T> {
    meta: Meta;
    data: T;
  }
}
