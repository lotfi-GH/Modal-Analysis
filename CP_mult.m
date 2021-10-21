%clear all;
function [ys,W] = CP_mult(im)
[rows, columns, numberOfColorChannels] = size(im);
% Make mixing matrix.
%A = randn(2,2);
%num_sources		= 3; 
max_mask_len= 500;
n=8;
h=2; t = n*h; lambda = 2^(-1/h); temp = [0:t-1]'; lambdas = ones(t,1)*lambda; mask = lambda.^temp; 
mask1 = mask/sum(abs(mask));


% Short-term mask
shf 		= 1; 
lhf 		= 900000; 	
h=shf; t = n*h; lambda = 2^(-1/h); temp = [0:t-1]'; 
lambdas = ones(t,1)*lambda; mask = lambda.^temp;
mask(1) = 0; mask = mask/sum(abs(mask));  mask(1) = -1;
s_mask=mask; s_mask_len = length(s_mask);



% Long-term mask.
h=lhf;t = n*h; t = min(t,max_mask_len); t=max(t,1);
lambda = 2^(-1/h); temp = [0:t-1]'; 
lambdas = ones(t,1)*lambda; mask = lambda.^temp;
mask(1) = 0; mask = mask/sum(abs(mask));  mask(1) = -1;
l_mask=mask; l_mask_len = length(l_mask);



% Filter each column of mixtures array.
S=filter(s_mask,1,im); 	
L=filter(l_mask,1,im);

% Find short-term and long-term covariance matrices.
U=cov(S,1);		
V=cov(L,1);



[W d]=eig(V,U); W=real(W);

ys = im*W;
%ys=W'*im;
W=W';
%ys=W'*im
