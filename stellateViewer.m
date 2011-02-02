function varargout = stellateViewer(varargin)
% STELLATEVIEWER M-file for stellateViewer.fig
%      STELLATEVIEWER, by itself, creates a new STELLATEVIEWER or raises the existing
%      singleton*.
%
%      H = STELLATEVIEWER returns the handle to a new STELLATEVIEWER or the handle to
%      the existing singleton*.
%
%      STELLATEVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STELLATEVIEWER.M with the given input arguments.
%
%      STELLATEVIEWER('Property','Value',...) creates a new STELLATEVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stellateViewer_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stellateViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help stellateViewer

% Last Modified by GUIDE v2.5 04-Jun-2010 14:30:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stellateViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @stellateViewer_OutputFcn, ...
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


% --- Executes just before stellateViewer is made visible.
function stellateViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stellateViewer (see VARARGIN)

% Choose default command line output for stellateViewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stellateViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stellateViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% --- Executes on button press in selectButton.
function selectButton_Callback(hObject, eventdata, handles)
% hObject    handle to selectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%gets input file(s) from user
[input_file,pathname] = uigetfile( ...
       {'*.SIG', 'Stellate (*.SIG)'; ...
        '*.*', 'All Files (*.*)'}, ...
        'Select files', ... 
        'MultiSelect', 'on');
 
%if file selection is cancelled, pathname should be zero
%and nothing should happen
if pathname == 0
    return
end

cd(pathname)

%gets the current data file names inside the listbox
inputFileNames = get(handles.fileListbox,'String');
 
%if they only select one file, then the data will not be a cell
%if more than one file selected at once,
%then the data is stored inside a cell
if iscell(input_file) == 0
 
    %add the most recent data file selected to the cell containing
    %all the data file names
    inputFileNames{end+1} = fullfile(pathname,input_file);
 
%else, data will be in cell format
else
    %stores full file path into inputFileNames
    for n = 1:length(input_file)
        %notice the use of {}, because we are dealing with a cell here!
        inputFileNames{end+1} = fullfile(pathname,input_file{n});
    end
end
 
%updates the gui to display all filenames in the listbox
set(handles.fileListbox,'String',input_file);
 
%make sure first file is always selected so it doesn't go out of range
%the GUI will break if this value is out of range
set(handles.fileListbox,'Value',1);
 
% Update handles structure
guidata(hObject, handles);


%% --- Executes on button press in getButton.
function getButton_Callback(hObject, eventdata, handles)
% hObject    handle to getButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputFileNames = get(handles.fileListbox,'String');

[NumRecs, NumSamps, NumSecs] = mGetFileLength(inputFileNames);

set(handles.second_output, 'String', num2str(NumSecs));
set(handles.samples_output, 'String', num2str(NumSamps));
set(handles.channel_output, 'String', num2str(mGetNumChan(inputFileNames)));
set(handles.sample_output, 'String', num2str(mGetTrueSampFreq(inputFileNames)));
set(handles.time_output, 'String', num2str(mGetRecStartTime(inputFileNames)));
montage = mGetMtgList(inputFileNames);
channels = mGetChanLabel(inputFileNames, montage{1});
set(handles.chlabels_listbox, 'String', channels);

mFileClose
guidata(hObject, handles);

%% --- Executes on selection change in fileListbox.
function fileListbox_Callback(hObject, eventdata, handles)
% hObject    handle to fileListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns fileListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fileListbox


%% --- Executes during object creation, after setting all properties.
function fileListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on selection change in propertyListbox.
function propertyListbox_Callback(hObject, eventdata, handles)
% hObject    handle to propertyListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns propertyListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from propertyListbox


%% --- Executes during object creation, after setting all properties.
function propertyListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to propertyListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text2.
function text2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on selection change in chlabels_listbox.
function chlabels_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to chlabels_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns chlabels_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chlabels_listbox


% --- Executes during object creation, after setting all properties.
function chlabels_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chlabels_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


