import localeSettings from './en-US/settings';
import localeMessageBox from './en-US/message-box';
import localeNavbar from './en-US/navbar';
import localeLogin from './en-US/login';
import localeException403 from './en-US/exception/403';
import localeException404 from './en-US/exception/404';
import localeException500 from './en-US/exception/500';
import localeMenu from './en-US/menu';
import localeSearchTable from './en-US/search-table';
import localeText from './en-US/text';
import localeModel from './en-US/model';

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
