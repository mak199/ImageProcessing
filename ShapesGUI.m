%%
%   Filename        :   MCCC_N.m
%   Matlab-Version  :   Matlab 7.8.0 (R2016a)
%   Date            :   15.12.2016
%   Author          :   Muhammad Afaque Khan,Samu Ullah
%   e-mail          :   muhammadafaque.khan@haw-hamburg.de
%   description     :   This program loads an image,preprocess it and
%                       detects the shapes present in the image

%%
function varargout = ShapesGUI(varargin)
% SHAPESGUI MATLAB code for ShapesGUI.fig
%      SHAPESGUI, by itself, creates a new SHAPESGUI or raises the existing
%      singleton*.
%
%      H = SHAPESGUI returns the handle to a new SHAPESGUI or the handle to
%      the existing singleton*.
%
%      SHAPESGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHAPESGUI.M with the given input arguments.
%
%      SHAPESGUI('Property','Value',...) creates a new SHAPESGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ShapesGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ShapesGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ShapesGUI

% Last Modified by GUIDE v2.5 12-Dec-2016 13:26:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ShapesGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ShapesGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ShapesGUI is made visible.
function ShapesGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ShapesGUI (see VARARGIN)

% Choose default command line output for ShapesGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.originalImage,'visible','off');
set(handles.preProcessedImage,'visible','off');
set(handles.shapeDetectedImage,'visible','off');
% UIWAIT makes ShapesGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ShapesGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadImage.
function loadImage_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile('*.*','Select a host image');
knownFormats = {'.jpeg','.jpg','.png'};
found = 0;
str = '';
for i=1:size(FileName,2)
    if FileName(1,i)=='.'
        found = 1;     
    end
    if found==1       
        str = strcat(str,FileName(1,i));
    end
end
available = ismember(knownFormats,str);
wrongfile = 0;
for i=1:size(available,2)
    if available(1,i)==1
        initialIMG = imread(FileName);
        % loads the host in the pane
        axes(handles.originalImage)
        image(initialIMG)
        axis off
        axis image
        % hObject    handle to loadImage (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)
        wrongfile = 1;
    end
end
if wrongfile==0
   str = sprintf('Wrong File Format.\nChoose a correct format file');
   msgbox(str,'Error','error');
else
   str = sprintf('File successfully loaded');
   msgbox(str,'Success');
end
 


% --- Executes on button press in preProcessImage.
function preProcessImage_Callback(hObject, eventdata, handles)
initialIMG = getimage(handles.originalImage);

if isempty(initialIMG)==0
    initialIMG = ShapeDetection(initialIMG,1);
    str = sprintf('Image successfully preprocessed');
    msgbox(str,'Success');
    axes(handles.preProcessedImage)
    image(initialIMG)
    axis off
    axis image
else
    str = sprintf('Image does not exist');
    msgbox(str,'Error','error');
end
% hObject    handle to preProcessImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in detectShapes.
function detectShapes_Callback(hObject, eventdata, handles)
rgbImageProcessed = getimage(handles.preProcessedImage);
if isempty(rgbImageProcessed)==0
    axes(handles.shapeDetectedImage);
    [~] = ShapeDetection(rgbImageProcessed,2);
    axis off
    axis image
    str = sprintf('Shapes successfully detected');
    msgbox(str,'Success');
else
    str = sprintf('Image does not exist');
    msgbox(str,'Error','error');
end

% hObject    handle to detectShapes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in loadDetectedImages.
function loadDetectedImages_Callback(hObject, eventdata, handles)
finalImage = getimage(handles.shapeDetectedImage);
loadImage = 'finalImage.jpg';
if isempty(finalImage)==0
    imwrite(finalImage,loadImage);
    str = sprintf('Image has been successfully loaded called ');
    str = strcat(str,loadImage);
    msgbox(str,'Success');
else
    str = sprintf('Image does not exist for loading');
    msgbox(str,'Error','error');
end
% hObject    handle to loadDetectedImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function help_Callback(hObject, eventdata, handles)
str = sprintf('1.LoadImage Button to load image of choice.\n2.PreProcess Image Button converts every image to an image with black background and without unwanted objects\n3.Detect Shapes Button runs the program to detect shapes in the image\n4.Load Image Button loads the original image with detected shapes into the given folder');
helpdlg(str,'How to use the Program?');
