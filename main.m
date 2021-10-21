clear all;

scaleAndClipLargeVideos = true; 

resultsDir = 'Results';
% Paths for the linear method
addpath(fullfile(pwd, 'matlabPyrTools'));
addpath(fullfile(pwd, 'matlabPyrTools', 'MEX'));

% Paths for the phase-based method
addpath(fullfile(pwd, 'pyrToolsExt'));





v = VideoReader('video-1-beam-raw-600.mp4');

info = get(v);



seq = im2double(v.read);

[height, width, numChannels, numFrames] = size(seq);


numLevels=maxSCFpyrHt(seq(:,:,1,1));
filt=3;
twidth=1;

refFrame=im2double(rgb2gray(seq(:,:,:,1)));

phase={};
nc={};

for i=1:size(seq,4)
    frame=im2double(rgb2gray(seq(:,:,:,i)));

    
    pyrRef = buildSCFpyr(refFrame, numLevels, filt, twidth);


    [pyrCA,INDICES] = buildSCFpyr(frame, numLevels, filt, twidth);

    deltaPhase= angle(pyrCA) - angle(pyrRef);

    deltaPhase=spyrLev(deltaPhase,INDICES,2);

    phase{end+1}=deltaPhase;
      
     
end


data=cell2mat(phase);
for i=1:size(data,1)
    data(i,:)=data(i,:)-mean(data(i,:));
end
for i=1:size(data,2)
    data(:,i)=data(:,i)-mean(data(:,i));
end
C=cov(data);



[coeff, score, latent, tsquared, explained, mu] = pca(C);
[~,n_components] = max(cumsum(explained) >= 95);
newdata =score(:,1:n_components);


[y,w]=CP_mult(newdata);

