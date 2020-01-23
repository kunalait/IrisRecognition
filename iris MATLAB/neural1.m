clear % Remove previous entries from memory
f=4e3; % Set a signal frequency of 4kHz
fm=300; % Set a frequency modulation of 300Hz
fa=200; % Set an amplitude modulation of 200Hz
ts=2e-5; % Set a sampling time of 0.2 msec
N=400; % Set 400 sampling points
t=(0:N-1)*ts; % Set a discrete time from 0 to 10 msec
v=(1+.2*sin(2*pi*fa*t)).*sin(2*pi*f*(1+.2*cos(2*pi*fm*t)).*t);%voice


fn=1e3; % Set signal frequency of 1kHz
n=randn(1,length(t))+sawtooth(2*pi*fn*t,0.7); % Create noise
a=[1 -0.6 -0.3]; % filter coefficients
c=filter(a,1,n); % Create output signal c from FIR filter


m=v+c; % Pilots voice contaminated with engine noise
net = newlin([min(n),max(n)],1); % Assume input values
net.inputWeights{1,1}.delays=[0 1 2 3]; % Specify 3 delays
net.IW{1,1} = [1 1 1 1]; % Give the various weights these values
net.b{1}=[0]; % Set the bias as 0
pi={1 1 1} % Define the initial output of the delays
n=num2cell(n); % Change arrays into the required cells
m=num2cell(m);
net.adaptParam.passes=1; % Specify 1 pass
[net,y,E pf,af]=adapt(net,n,m,pi); % Perform the training


net = newlin([min(n),max(n)],1); % Assume input values
net.inputWeights{1,1}.delays=[0 1 2 3]; % Specify 3 delays
net.IW{1,1} = [1 1 1 1]; % Give the various weights these values
net.b{1}=[0]; % Set the bias as 0
pi={1 1 1} % Define the initial output of the delays
n=num2cell(n); % Change arrays into the required cells
m=num2cell(m);
net.adaptParam.passes=1; % Specify 1 pass
[net,y,E pf,af]=adapt(net,n,m,pi); % Perform the training


temp=zeros(400,1);  % Convert cell array into boolean array for plot
for i=1:400
temp(i,1)=y{1,i}(1,1);
end
temp=temp'; % Transpose the boolean array
m=cat(2,m{:});
error=(v-(m-temp)); % Calculate error of signal
error2=0;
temp=zeros(400,1);
for i=1:400
error2=error2+abs(error(i)); %Calculate mean error
end
error3=error2/400; % average error


% Define MLP
net=newff([-10,10;-10,10;-10,10;-10,10;-10,10;-10,10],...
[6,4,1],{'tansig','tansig','tansig'},'traingdm');
% Initialise the network
net=init(net);


net.trainParam.lr=0.01; % set learning rate to value of 0.01
net.trainParam.mc= 0.90;
% momentum set to the value of 0.90
net.trainParam.goal=1e-5;  % goal set to the mean squared error of 1e-5

net.trainParam.show=10000; % Update graph after every 10000 epochs performed
net.trainParam.epochs=50000; % Set maximum number of epoch performed to be 50000

c = 3e8; %  Speed of light in free space
cf=1605e3; % Define carrier frequency for desired signal (range is 535e3 Hz - 1605e3Hz)
d = 0.5*(c/cf); % Antennas separated by 1/4 wavelength (meters)
angddegrees = -40; % Define angle of arrival for desired signal (in degrees)
angidegrees = 0; % Define angle of arrival of interference signal (in degrees)
angd = angddegrees*(pi/180); % Angle of arrival for desiredsignal (in radians)
angi = angidegrees*(pi/180); % Angle of arrival for interference signal (in radians)
deld = d*(sin(angd)/c); % Delay between elements for desired signal
deli = d*(sin(angi)/c); % Delay between elements for interference signal


A=1; % Define amplitude of carrier frequency for desired signal, i.e. A
m=0.5; % Define modulation depth for desired signal (range is 0 - 1)
mf=20e3; % Define modulating frequency for desired signal (range is 20 Hz - 20e3 Hz)
wc=2*pi*cf; % Carrier angular frequency for desired signal (radians)
wm=2*pi*mf; % Modulating angular frequency for desired signal (radians)
fs=round(wc*20/(2*pi)); % Set a sampling frequency 20x maximum carrier frequency
N = 1500; % Define number of sample values to be 1500
t=(0:N-1)*(1/fs); % Set the sampling time and sampling intervals
signal= A*(1+m*cos(wm*t)).*(cos(wc*t)); % Desired signal transmitted
% signal1 is signal to arrive at antenna 1
% signal2 is signal to arrive at antenna 2
% signal3 is signal to arrive at antenna 3
% Signals are different due to delays
% All the signals have random noise added to them (SNR is 30dB)
signal1 = (A*(1+m*cos(wm*t)).*(cos(wc*t)))+(.03*randn(1,length(t)));
signal2 = (A*(1+m*cos(wm*t)).*(cos(wc*(t+deld))))+(.03*randn(1,length(t)));
signal3 = (A*(1+m*cos(wm*t)).*(cos(wc*(t+(2*deld)))))+(.03*randn(1,length(t)));


iA=1; % Define amplitude of carrier frequency for interference signal
im=0.5; %  Define modulation depth for interference signal (range is 0 - 1)
icf=1605e3; % Define carrier frequency for interference signal (range is 535e3 Hz -
% 1605e3 Hz)
imf=20e3; % Define modulating frequency for interference signal (range is 20-20e3 Hz)
iwc=2*pi*icf; %  Carrier angular frequency for interference signal (radians)
iwm=2*pi*imf; % Modulating angular frequency for interference signal (radians)
% interferenceSignal1 is interference to arrive at antenna 1
% interferenceSignal2 is interference to arrive at antenna 2
% interferenceSignal3 is interference to arrive at antenna 3
% Signals are different due to delays
% All the signals have random noise added to them (SNR is 30dB)
interferenceSignal1=  (iA*(1+im*cos(iwm*t)).*(cos(iwc*t)))+(.03*randn(1,length(t)));
interferenceSignal2=  (iA*(1+im*cos(iwm*t)).*(cos(iwc*(t+deli))))+...
(.03*randn(1,length(t)));
interferenceSignal3 = (iA*(1+im*cos(iwm*t)).*(cos(iwc*(t+(2*deli)))))+...
(.03*randn(1,length(t)));

% Signal to impinge on each antenna is defined to be desired signal + interference
signal
for z=1:N
inputSignal1(1,z)=signal1(1,z)+interferenceSignal1(1,z);
inputSignal2(1,z)=signal2(1,z)+interferenceSignal2(1,z);
inputSignal3(1,z)=signal3(1,z)+interferenceSignal3(1,z);
end


% Hilbert transform performed to create outputs from quadrature hybrids
hil1 = imag(hilbert(inputSignal1));
hil2 = imag(hilbert(inputSignal2));
hil3 = imag(hilbert(inputSignal3));
% Define inputs into MLP
inputArray=[inputSignal1;hil1;inputSignal2;hil2;inputSignal3;hil3];


secondmf=20; %  Define modulating frequency for second desired signal (range is 20 Hz
% - 20e3 Hz)
secondwm=2*pi*secondmf; %Modulating angular frequency for second desired signal (rad)
secondsignal=A*(1+m*cos(secondwm*t)).*(cos(wc*t)); % Second desired signal transmitted
% secondsignal1 is second signal to arrive at antenna 1
% secondsignal2 is second signal to arrive at antenna 2
% secondsignal3 is second signal to arrive at antenna 3
% Signals are different due to delays
% All the signals have random noise added to them (SNR is 30dB)
secondsignal1 = (A*(1+m*cos(secondwm*t)).*(cos(wc*t)))+(.03*randn(1,length(t)));
secondsignal2 = (A*(1+m*cos(secondwm*t)).*(cos(wc*(t+deld))))+...
(.03*randn(1,length(t)));
secondsignal3 = (A*(1+m*cos(secondwm*t)).*(cos(wc*(t+(2*deld)))))+...
(.03*randn(1,length(t)));


secondim=0.9; %  Define modulation depth for second interference signal
%(range is 0 - 1)
secondicf=535e3;
% Define carrier frequency for second interference signal
%(range is 535e3 Hz - 1605e3 Hz)
secondimf=100; %  Define modulating frequency for second interference signal
%(range is 20 Hz - 20e3 Hz)
secondiwc=2*pi*secondicf; %  Carrier angular frequency for second interference signal
%(radians)
secondiwm=2*pi*secondimf;
%  Modulating angular frequency for second interference
% signal (radians)
% secondinterferenceSignal1 is second interference signal to arrive at antenna 1
% secondinterferenceSignal2 is second interference signal to arrive at antenna 2
% secondinterferenceSignal3 is second interference signal to arrive at antenna 3
% Signals are different due to delays
% All the signals have random noise added to them (SNR is 30dB)
secondinterferenceSignal1 =...
(secondiA*(1+secondim*cos(secondiwm*t)).*(cos(secondiwc*t)))+(.03*randn(1,length(t)));
secondinterferenceSignal2 =...
(secondiA*(1+secondim*cos(secondiwm*t)).*(cos(secondiwc*(t+deli))))...
+(.03*randn(1,length(t)));
secondinterferenceSignal3 =...
(secondiA*(1+secondim*cos(secondiwm*t)).*(cos(secondiwc*(t+(2*deli)))))...
+(.03*randn(1,length(t)));


% Second signal to impinge on each antenna is defined to be second desired signal +
% second interference signal
for z=1:N
secondinputSignal1(1,z)=secondsignal1(1,z)+secondinterferenceSignal1(1,z);
secondinputSignal2(1,z)=secondsignal2(1,z)+secondinterferenceSignal2(1,z);
secondinputSignal3(1,z)=secondsignal3(1,z)+secondinterferenceSignal3(1,z);
end

% Hilbert transform performed on second input signal to create outputs from quadrature
% hybrids
secondhil1 = imag(hilbert(secondinputSignal1));
secondhil2 = imag(hilbert(secondinputSignal2));
secondhil3 = imag(hilbert(secondinputSignal3));
% Define second inputs into MLP
secondinputArray=[secondinputSignal1;secondhil1;...
secondinputSignal2;secondhil2;secondinputSignal3;secondhil3];


% Normalise the two signals which are transmitted
[normSignal,minnormSignal,maxnormSignal]=premnmx(signal);
[normsecondSignal,minnormsecondSignal,maxnormsecondSignal]=premnmx(secondsignal);
% Define target data
targetArray=normSignal;
secondtargetArray=normsecondSignal;


% Define two arrays for the target data and the input data
targetdata=[];
inputdata=[];
% Interleave values so that the network is not biased towards any particular values
for x=1:N
inputdata=[inputdata,inputArray(:,x)];
inputdata=[inputdata,secondinputArray(:,x)];
targetdata=[targetdata,targetArray(:,x)];
targetdata=[targetdata,secondtargetArray(:,x)];
end


% Train network ('inputdata' as input; 'targetdata' as the target data)
net=train(net,inputdata,targetdata);

% Simulate network with data that it was trained with
temp=sim(net,inputArray);
temp2=sim(net,secondinputArray);
% Post-process output from MLP
output1=postmnmx(temp,minnormSignal,maxnormSignal);
output2=postmnmx(temp2,minnormSignal,maxnormSignal);

