function[]=TestImage(fx,fy,a)

%The pixels of the pattern image is fixed,but can be changed
pixels = 200;
%The pixels need to be divided by the required frequency in order to get
%correct frequency in different pattern function
freqX = pixels/fx;
freqY = pixels/fy;

%if a is 1 then return a vertical pattern else return other patterns
%depending on what variable 'a' is
if a==1
    grayImage = vertical(freqY);
elseif a==2
    grayImage = horizontal(freqX);
elseif a==3
    grayImage = diagonal(freqX,freqY);
elseif a==4
    grayImage = chessBoard(freqX,freqY);
elseif a==5 
    grayImage = whiteSquare(fx,fy);
elseif a==6 
    grayImage = gaussian(freqX,freqY);
end
%disp function creates subplot and displays the pattern and its spectrum
disp(grayImage);

end

%disp function creates subplot and displays the pattern and its spectrum
function[]=disp(grayImage)
fontSize = 20;
subplot(2,2,1);
imshow(grayImage);
title('Original Gray Scale Image', 'FontSize', fontSize);
fftImage = fft2(grayImage);
fftshiftImage = fftshift(fftImage);
subplot(2,2,2);
imshow(real(fftshiftImage));
title('Real Part of Spectrum', 'FontSize', fontSize);
subplot(2,2,3);
imshow(imag(fftshiftImage));
title('Imaginary Part of Spectrum', 'FontSize', fontSize);
subplot(2,2,4);
imshow(log(abs(fftshiftImage)),[]);
title('Log Magnitude of Spectrum', 'FontSize', fontSize);
end

%horizontal function creates horizontal stripe patterns
function[mask]=horizontal(fx)
fy = 0;
fx = 1/fx;
Nx = 200;
Ny = 200;
[x,y] = ndgrid(1:Nx,1:Ny);
mask = (((sin(2*pi*(fx*x + fy*y))))+1)/2;
end

%vertical function creates horizontal stripe patterns
function[mask]=vertical(fy)
fx = 0;
fy = 1/fy;
Nx = 200;
Ny = 200;
[x,y] = ndgrid(1:Nx,1:Ny);
mask = (sin(2*pi*(fx*x + fy*y))+1)/2;
end

%chessBoard function creates chessboard based pattern
function[y]=chessBoard(fx,fy)
ver = vertical(fy);
hor = horizontal(fx);
y = zeros(length(ver),length(ver));
y = ver.*hor;
end

%diagonal function creates diagonal pattern,with frequencies in x and y direction
function[mask]=diagonal(fx,fy)
fy = 1/fy;
fx = 1/fx;
Nx = 200; % image dimension in x direction
Ny = 200; % image dimension in y direction
[xi, yi] = ndgrid(1 : Nx, 1 : Ny);

mask = (sin(2 * pi * (fx * xi  + fy * yi)));

end
%gaussian function creates gaussian pattern with diagonal stripes
function[mat] = gaussian(fx,fy)
sigma = 100;
center = 100;
gsize = 200;
[R,C] = ndgrid(1:gsize, 1:gsize);
mat = gaussC(R,C, sigma, center)+ diagonal(fx,fy);
end
%gaussian function gaussian pattern
function[val] = gaussC(x, y, sigma, center)
xc = sigma;
yc = center;
exponent = ((x-xc).^2 + (y-yc).^2)./(2*sigma);
val       = 1000*(exp(-exponent));    

end
%whiteSquare function creates image with a white square in the center
function[sum]= whiteSquare(fx,fy)
t = -10:0.1:9.9;
gray = zeros(length(t),length(t));
x = sinc(fx*t);
y = sinc(fy*t);
for i=1:length(x)
   if mod(i,2)==1
       x(i) = -x(i);
       y(i) = -y(i);
   end
end
fftx = abs(ifft(x))*180;
ffty = abs(ifft(y))*180;
for i=1:length(t)
    gray(i,:) = fftx;    
end
gray1 = zeros(length(t),length(t));
for i=1:length(t)
    gray1(:,i) = ffty;    
end
sum = gray.*gray1;

end
