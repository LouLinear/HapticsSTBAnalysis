classdef STBData < handle
	
	properties
		subj_id
		task_id
		forces
		moments
		acc1
		acc2
		acc3
		duration
		plot_time
		time
        index
        filename
        youtube
        youtube_short
        score
        rater
        fam
	end

	methods 
        
        function obj = STBData(dataDir, csvFileName, varargin)
            
            p = inputParser;
            p.addOptional('task', 1:3, @(x) all(ismember(x, [1 2 3])));
            p.parse(varargin{:});
            inputs = p.Results;
            
            fileName = dir([dataDir, '/', csvFileName, '/*.mat']);
            
            if (ismember(str2double(fileName.name(6)), inputs.task))
                disp(['Loading: ' fileName.name])
                % Load rawData, rating(not recorded yet) and
                % youtube address from .mat
                load([dataDir '/' csvFileName '/', fileName.name], 'rawData', 'youtube', 'youtube_short', 'score', 'rater');
                
                obj.filename = fileName;
                obj.youtube = youtube; %#ok<NODEF>
                obj.youtube_short = youtube_short; %#ok<NODEF>
                obj.forces = rawData(:,1:3); %#ok<NODEF>
                obj.moments = rawData(:,4:6);
                obj.acc1 = rawData(:,7:9);
                obj.acc2 = rawData(:,10:12);
                obj.acc3 = rawData(:,13:15);
                obj.duration = (size(rawData,1)-1)/3000;
                obj.plot_time = (0:size(rawData,1)-1)/3000;
                
                obj.time = datetime(fileName.name(8:end-4), 'InputFormat', 'MM-dd_HH-mm');
                
                obj.subj_id = str2double(fileName.name(2:4));
                obj.task_id = str2double(fileName.name(6));
                
                obj.score = 0;
                obj.rater = 0;
                
                obj.index = 1;
               
                clear rawData youtube youtube_short score rater
            end
        end
        
		function obj = STBData_noeval(dataDir, varargin)
			if nargin ~= 0
                
	            subjectDirs = dir([dataDir '/*.mat']);
	            subjFound = obj.findSubj(subjectDirs);
	            nTrials = zeros(length(subjectDirs),1);

	            p = inputParser;
                p.addOptional('task', 1:3, @(x) all(ismember(x, [1 2 3])));
                p.addOptional('subject', subjFound, @(x) all(ismember(x, subjFound)));
                p.parse(varargin{:});
                inputs = p.Results;

                subjectDirs = subjectDirs(ismember(subjFound, inputs.subject));

	            for i = 1:length(subjectDirs)
	            	nTrials(i) = length(dir([dataDir '/' subjectDirs(i).name '/*.mat']));
	            end

	            obj(sum(nTrials)) = STBData();

	            k = 1;
                for i = 1:length(subjectDirs)
	            	trialFiles = dir([dataDir '/' subjectDirs(i).name  '/*.mat']);
					for j = 1:length(trialFiles)
						if any(ismember(str2double(trialFiles(j).name(6)),inputs.task))
		            		disp(['Loading: ' trialFiles(j).name])
		            		% Load rawData, rating(not recorded yet) and
		            		% youtube address from .mat
                            load([dataDir '/' subjectDirs(i).name '/' trialFiles(j).name], 'rawData', 'youtube', 'youtube_short', 'score', 'rater');
                            
                            obj(k).filename = [dataDir '/' subjectDirs(i).name '/' trialFiles(j).name];
                            obj(k).youtube = youtube; %#ok<CPROP>
                            obj(k).youtube_short = youtube_short; %#ok<CPROP> 
		                    obj(k).forces = rawData(:,1:3); %#ok<NODEF>
		                    obj(k).moments = rawData(:,4:6);
		                    obj(k).acc1 = rawData(:,7:9);
		                    obj(k).acc2 = rawData(:,10:12);
		                    obj(k).acc3 = rawData(:,13:15);
		                    obj(k).duration = (size(rawData,1)-1)/3000;
		                    obj(k).plot_time = (0:size(rawData,1)-1)/3000;

		                    obj(k).time = datetime(trialFiles(j).name(8:end-4), 'InputFormat', 'MM-dd_HH-mm');

		                    obj(k).subj_id = str2double(trialFiles(j).name(2:4));
		                    obj(k).task_id = str2double(trialFiles(j).name(6));
	                        
                            obj(k).score = score;
                            obj(k).rater = rater;
                            
	                        obj(k).index = k;
	                        
		                    k = k +1;
                            
                            clear rawData youtube youtube_short score rater
						end
					end
                end
                obj(k:end) = [];
			end
		end

		function val = subject(obj, subjDes)
			if (isequal(size(obj), [1 1]) || nargin == 1)
				val = [obj.subj_id];
			else
				val = obj([obj.subj_id] == subjDes);
			end
        end

		function val = task(obj, taskDes)
			if (isequal(size(obj), [1 1]) || nargin == 1)
				val = [obj.task_id];
			else
				val = obj([obj.task_id] == taskDes);
			end
        end
        
        function subjects = findSubj(~, subjectDirs)
        	subjects = zeros(size(subjectDirs));
            for i = 1:length(subjects)
        		subjects(i) = str2double(subjectDirs(i).name(end-2:end));
            end
        	subjects = sort(subjects);
        end
    
        plotMom(obj, range)
        plotForces(obj, range)
        plotAcc(obj, arg1, arg2)
        newObj = range(rangeIdx)

    end

end