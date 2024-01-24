import { getCurrentInstance } from 'vue';

const useMessage = () => {
  const currentInstance = getCurrentInstance();
  if (!currentInstance) {
    throw new Error('Cannot get vue instance');
  }

  const context = currentInstance.appContext;
  return context.config.globalProperties.$message;
};

export default useMessage;
