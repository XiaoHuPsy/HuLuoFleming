clear;

%% load data and model name
load modelList_Confidence % load model name

parentFolder = fileparts(pwd);
dataName = 'modelfit_data_Confidence_Exp2a.mat'; % load data for Experiment 2a or 2b
load(fullfile(parentFolder,'data_for_modeling',dataName));

%% Sampling
% MCMC Parameters
nchains = 4; % How Many Chains?
nburnin = 5e4; % How Many Burn-in Samples?
nsamples = 5e4;  %How Many Recorded Samples?
nthin = 1; % How Often is a Sample Recorded?
doparallel = 1; % Parallel Option

% Assign Matlab Variables to the Observed Nodes
datastruct = struct('C',C,'condition',condition,'nsubj',nsubj,'ntrial',ntrial,'confcondition',confcondition,'prec',prec,'conf',conf,'sub',sub);

% Initialize Unobserved Variables
for i=1:nchains
    S = struct;
    init0(i) = S;
end

% Use JAGS to Sample
for i=1:length(modelName)
    
    monitorParams = {'groupUbeta0','groupVbeta0','groupUbias','groupVbias','sigmaconf','beta0','beta1','bias'};
    
    tic
    fprintf( 'Running JAGS ...\n' );
    [samples, stats] = matjags( ...
        datastruct, ...
        fullfile(parentFolder,'model_file','Confidence',modelName{i}), ...
        init0, ...
        'doparallel' , doparallel, ...
        'nchains', nchains,...
        'nburnin', nburnin,...
        'nsamples', nsamples, ...
        'thin', nthin, ...
        'monitorparams', monitorParams, ...
        'savejagsoutput' , 1 , ...
        'verbosity' , 1 , ...
        'cleanup' , 0 , ...
        'workingdir' , 'tmpjags' );
    toc
    
    % save samples and stats
    savename = strrep(modelName{i},'.txt','.mat');
    save(['samp_' savename],'samples');
    save(['stat_' savename],'stats');
    
    fprintf( [['\n Finish '] num2str(i) ['/'] num2str(length(modelName)) [' Models\n\n']] );
    
end

fprintf( 'Finish fitting all models!\n' );