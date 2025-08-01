close all;clear;

predata = dlmread('output_a1.txt');%predict data
realdata= dlmread('./data_for_ML/WSS_sample 1.txt');
%realdata2= dlmread('./data_for_ML/WSS_sample 2.txt');
%realdata3= dlmread('./data_for_ML/WSS_sample 3.txt');
%realdata4= dlmread('./data_for_ML/WSS_sample 4.txt');
%realdata5= dlmread('./data_for_ML/WSS_sample 5.txt');
%realdata6= dlmread('./data_for_ML/WSS_sample 6.txt');
%realdata7= dlmread('./data_for_ML/WSS_sample 7.txt');

%% find best threshold
realprune = realdata(:,end);

thresh = linspace(0,1,101);
l2 = length(thresh);
IOU = zeros(l2,1);
%calculate IOU for all threshold
for i = 1:101
    pre_tempt = predata>thresh(i);
    overlap=min(pre_tempt,realprune);
    union=max(pre_tempt,realprune);
    IOU(i) = sum(overlap(:))/sum(union);
end

bth = thresh(IOU==max(IOU));%find the threshold for max IOU
max(IOU)
% plot th-IOU figure
figure(1);
plot(thresh,IOU,'LineWidth',5)
%hold on;
% plot([bth bth],[0,max(IOU)])

xlabel('Threshold (th)','fontweight','bold', 'fontsize',30)
ylabel('Intersection over Union (IoU)','fontweight','bold','fontsize',30)
set(gca,'FontSize',20);
set(gca,'linewidth',2)
%set(gca,'xtick',[])
%set(gca,'ytick',[])
%set(gca,'xticklabel',[])
set(gca,'TickLength',[0, 0])
ylim([0 0.25])
%saveas(gcf, 'IOU_model1.tif');

%hold off
%% plot the image for experiment and model
prevessel = zeros(358,774);%unpruned vessels in model
realvessel = zeros(358,774);%unpruned vessels in experiment
preprune = zeros(358,774);%pruned vessels in model
realprune = zeros(358,774);%pruned vessels in experiment
real=realdata(realdata(:,3)==12,:);%only the middle surface is ploted
pre = predata(realdata(:,3)==12);
%real=realdata(realdata(:,12),:);%only the middle surface is ploted
%pre = predata(realdata(:,12);

pre = pre>bth;
% pre = pre<-0.3;
l = length(pre);
for i=1:l
    x = real(i,1);
    y = real(i,2);
    
    realprune(x,y) = real(i,end);
    preprune(x,y) = pre(i);
    realvessel(x,y) = 1-real(i,end);
    prevessel(x,y) = 1-pre(i);
 
end

realprune = (realprune).';
 realprune =flipud(realprune); 

preprune = (preprune).';
 preprune = flipud(preprune);

realvessel = (realvessel).';
 realvessel = flipud(realvessel);

 prevessel = (prevessel).';
 prevessel = flipud(prevessel);

 [row,col]=find(preprune==1);
preprune1=preprune(:);

 figure(2);
 imshowpair(preprune,realprune)

 figure(3);
 imshowpair(realvessel,realprune)
 title('Real pruned vessels')
 %saveas(gcf, 'real_pruned_vessels.tif');

 figure(4);
 imshowpair(prevessel,preprune)
 title('Pruned vessels predicated by ML')
 %saveas(gcf, 'ML_predicted_pruned_vessels.tif');