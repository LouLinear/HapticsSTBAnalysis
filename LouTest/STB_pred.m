function ratings = STB_pred(task, rounding)
    %to be called from pythong to do 
    addpath 'LIBSVM'
    addpath 'ML'
    addpath 'glmnet_matlab'
    
    %convertToMat(fileName)
    [~, csvFileName] = loadcsv('tempcsv', 'evalMat');
    
    feats = Signal2Feature('evalMat', csvFileName, task, rounding);
    ratings = RegressionPredict(feats, rounding);
end