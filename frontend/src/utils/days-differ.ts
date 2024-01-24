import dayjs, { ManipulateType } from 'dayjs';

export const daysDiffer = (
  date1: Date | null | undefined,
  date2: Date | null | undefined
) => {
  if (!date1 || !date2) return 0;

  const dayOne = dayjs(date1).startOf('day');
  const dayTwo = dayjs(date2).startOf('day');

  return dayOne.diff(dayTwo, 'day');
};

export const addTime = (
  date: Date | string,
  period: number,
  unit: ManipulateType
) => {
  const dayJsDate = dayjs(date).startOf('day');
  return dayJsDate.add(period, unit).toDate();
};

export const timeDiffer = (
  date1: Date | null | undefined,
  date2: Date | null | undefined
) => {
  if (!date1 || !date2) return '';

  const dayOne = dayjs(date1).endOf('day');
  const dayTwo = dayjs(date2);

  const diff = dayOne.diff(dayTwo, 'second');

  const days = Math.floor(diff / (24 * 60 * 60)); // convert seconds to days
  const hours = Math.floor((diff % (24 * 60 * 60)) / (60 * 60)); // leftover seconds to hours
  const seconds = diff % 60; // leftover seconds

  return `${Math.floor(days)} 天 ${Math.floor(hours)} 小时 ${Math.floor(
    seconds
  )} 秒`;
};
