// export type RoleType = '' | '*' | 'admin' | 'user';
export interface UserState {
  id?: number;
  username?: string;
  name?: string;
  admin?: boolean;
  role_names?: string[];
  permission_names?: string[];
  user_type?: string;
  // name?: string;
  // avatar?: string;
  // job?: string;
  // organization?: string;
  // location?: string;
  // email?: string;
  // introduction?: string;
  // personalWebsite?: string;
  // jobName?: string;
  // organizationName?: string;
  // locationName?: string;
  // phone?: string;
  // registrationDate?: string;
  // accountId?: string;
  // certification?: number;
  // role: RoleType;
}
