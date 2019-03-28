clear;

%% load data and model name
load modelList_ChoiceAndRecall % load model name

parentFolder = fileparts(pwd);
dataName = 'modelfit_data_ChoiceAndRecall_Exp1.mat'; % load data for Experiment 1 or 2a or 2b
load(fullfile(parentFolder,'data_for_modeling',dataName));

%% Sampling
% MCMC Parameters
nchains = 4; % How Many Chains?
nburnin = 5e4; % How Many Burn-in Samples?
nsamples = 5e4;  %How Many Recorded Samples?
nthin = 1; % How Often is a Sample Recorded?
doparallel = 1; % Parallel Option

% Assign Matlab Variables to the Observed Nodes
datastruct = struct('ask',ask,'condition',condition,'nsubj',nsubj,'ntrial',ntrial,'recall',recall,'rectrial',rectrial,'sub',sub);

% Initialize Unobserved Variables
for i=1:nchains
    S = struct;
    init0(i) = S;
end

% Use JAGS to Sample
for i=1:length(modelName)
    
    if ~isempty(strfind(modelName{i},'constant')) % constant model
        monitorParams = {'groupUbeta','groupVbeta','sigmaRecall','groupUhintobj','groupVhintobj','beta','V_recall','U_hint_obj'};
    else % positive- or negative-slope model
        monitorParams = {'groupUC','groupVC','sigmaRecall','groupUhintobj','groupVhintobj','C','V_recall','U_hint_obj'};
    end
    
    tic
    fprintf( 'Running JAGS ...\n' );
    [samples, stats] = matjags( ...
        datastruct, ...
        fullfile(parentFolder,'model_file','ChoiceAndRecall',modelName{i}), ...
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