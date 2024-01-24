export const apiString = (value: string) => {
  return value === '' ? undefined : value;
};

export const apiNumber = (value: number) => {
  return Number.isNaN(value) ? undefined : value;
};
