import dayjs from 'dayjs';

export const formatTime = (time: any) => {
  return dayjs(time).format('YYYY-MM-DD HH:mm:ss');
};

export const formatDate = (date: any) => {
  if (!date) {
    return '';
  }

  return dayjs(date).format('YYYY-MM-DD');
};

export const shortFormatDate = (date: Date) => {
  return dayjs(date).format('DD/MM/YY');
};
