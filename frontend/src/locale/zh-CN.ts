import localeSettings from './zh-CN/settings';
import localeMessageBox from './zh-CN/message-box';
import localeNavbar from './zh-CN/navbar';
import localeLogin from './zh-CN/login';
import localeException403 from './zh-CN/exception/403';
import localeException404 from './zh-CN/exception/404';
import localeException500 from './zh-CN/exception/500';
import localeMenu from './zh-CN/menu';
import localeSearchTable from './zh-CN/search-table';
import localeText from './zh-CN/text';
import localeModel from './zh-CN/model';

export default {
  ...localeSettings,
  ...localeMessageBox,
  ...localeNavbar,
  ...localeLogin,
  ...localeException403,
  ...localeException404,
  ...localeException500,
  ...localeMenu,
  ...localeSearchTable,
  ...localeText,
  ...localeModel,
};
