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
  interface HttpResponse<T = unknown> {
    status?: number;
    msg?: string;
    code?: number;
    data?: T;
  }
  type AxiosResponse<T = any> = HttpResponse<T>;
}
