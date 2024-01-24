export const arcoDesignColors = [
  '#3491FA',
  '#165DFF',
  '#722ED1',
  '#F7BA1E',
  '#FADC19',
  '#9FDB1D',
  '#00B42A',
  '#14C9C9',
  '#F53F3F',
  '#F77234',
  '#FF7D00',
  '#D91AD9',
  '#D91AD9',
];

export function randomColor() {
  return arcoDesignColors[Math.floor(Math.random() * arcoDesignColors.length)];
}
