function varargout = edited_circuit_simulator(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @edited_circuit_simulator_OpeningFcn, ...
                   'gui_OutputFcn',  @edited_circuit_simulator_OutputFcn, ...
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


% --- Executes just before edited_circuit_simulator is made visible.
function edited_circuit_simulator_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for edited_circuit_simulator
handles.output = hObject;

%define arrays
handles.component_arr={};
handles.start_node_arr=[];
handles.end_node_arr=[];
handles.values_arr=[];

%intialize variables
handles.value=NaN;
handles.start_node=NaN;
handles.end_node=NaN;
handles.unit_factor=1;
handles.component_count=0;

% Initialize pop-up menus
handles.component = findobj('Tag', 'component_menu'); 
handles.unit = findobj('Tag', 'unit_menu'); 
    
% Set default values for pop-up menus
set(handles.component, 'Value', 1); % Set default value (e.g., first item)
set(handles.unit, 'Value', 1); % Set default value (e.g., first item)


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes edited_circuit_simulator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = edited_circuit_simulator_OutputFcn(~, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on selection change in component_menu.
function component_menu_Callback(hObject, eventdata, handles)

    contents = cellstr(get(hObject,'String'));
    handles.component=contents{get(hObject,'value')};
    guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function component_menu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in unit_menu.
function unit_menu_Callback(hObject, eventdata, handles)
    
    contents = cellstr(get(hObject,'String'));
    unit=contents{get(hObject,'value')};
    switch unit
        case 'G' ,factor = 1e9;
        case 'M' ,factor = 1e6;
        case 'K' ,factor = 1e3;
        case 'unit' ,factor = 1;
        case 'm' ,factor = 1e-3;
        case 'u' ,factor = 1e-6;
        case 'n' ,factor = 1e-9;
        otherwise ,factor = 1;  
    end

handles.unit_factor=factor;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function unit_menu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function value_in_Callback(hObject, eventdata, handles)
    handles.value = str2double(get(hObject,'String'));
    guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function value_in_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in add_button.
function add_button_Callback(hObject, eventdata, handles)

    %get variables
        value=handles.value;
        start_node=handles.start_node;
        end_node=handles.end_node;
        unit_factor=handles.unit_factor;
        value=value * unit_factor;
        i=handles.component_count;
        component_name=handles.component;

 %check if inputs have valid values
       
      % Validate node numbers
       % Validate if node numbers are numeric
        if ~isnumeric(start_node) || ~isnumeric(end_node) || isnan(start_node) || isnan(end_node)
            set(handles.error1, 'String', 'Node numbers must be numeric values.');
            return;
        end
    
        % Check if node numbers are integers
        if (start_node ~= floor(start_node)) || (end_node ~= floor(end_node))
            set(handles.error1, 'String', 'Node numbers must be integers.');
            return;
        end
    
        % Check if node numbers are non-negative
        if (start_node < 0) || (end_node < 0)
            set(handles.error1, 'String', 'Node numbers must be non-negative.');
            return;
        end
    
        % Validate component value
        if isnan(value) || value <= 0
            set(handles.error1, 'String', 'Invalid component value.');
            return;
        end
    
        % If all validations pass, clear the error message
        set(handles.error1, 'String', '');



  
  %update component counter 
       i=i+1;
       handles.component_count=i;



   %update arrays with new component 
    handles.component_arr{i}=component_name;
    handles.start_node_arr(i)=start_node;
    handles.end_node_arr(i)=end_node;
    handles.values_arr(i)=value;






    %delete after every element
    set(handles.value_in,'String','');
    set(handles.node1_in, 'String', '');
    set(handles.node2_in, 'String', '');
     
    component_popup = findobj(handles.figure1, 'Tag', 'component_menu');
    unit_popup = findobj(handles.figure1, 'Tag', 'unit_menu');
    
    % Clear the component pop-up menu
    set(component_popup, 'Value', 1); % Set to default value (e.g., first item)
    
    % Clear the unit pop-up menu
    set(unit_popup, 'Value', 1); % Set to default value (e.g., first item)
    
    set(handles.error1, 'String', '');  % Clear any previous error messages 
    %clear stored nodes an value
    handles.value=NaN;
    handles.start_node=NaN;
    handles.end_node=NaN;
    handles.unit_factor=1;
        
    guidata(hObject,handles);

function node2_in_Callback(hObject, eventdata, handles)
    handles.end_node= str2double(get(hObject,'String'));
    guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function node2_in_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function node1_in_Callback(hObject, eventdata, handles)

handles.start_node= str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function node1_in_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in solve_button.
%function solve_button_Callback(hObject, eventdata, handles)
function solve_button_Callback(hObject, eventdata, handles)
    % Get the max_node to initialize matrices
    max_node = max(max(handles.start_node_arr), max(handles.end_node_arr));

    % Define matrices
    G = zeros(max_node, max_node);  % Conductance matrix
    I = zeros(max_node, 1);         % Current vector
    V = zeros(max_node, 1);         % Voltage vector
    
    component_arr = handles.component_arr;
    start_node_arr = handles.start_node_arr;
    end_node_arr = handles.end_node_arr;
    values_arr = handles.values_arr;

    % Initialize the matrix size for voltage sources
    num_voltage_sources = sum(strcmp(component_arr, 'Voltage'));
    G = [G zeros(max_node, num_voltage_sources)];
    G = [G; zeros(num_voltage_sources, max_node + num_voltage_sources)];
    I = [I; zeros(num_voltage_sources, 1)];

    voltage_source_index = 1;  % To keep track of voltage sources

    for i = 1:handles.component_count
        switch component_arr{i}
            case 'Resistor'
                % Add resistor to G matrix
                if start_node_arr(i) > 0
                    G(start_node_arr(i), start_node_arr(i)) = G(start_node_arr(i), start_node_arr(i)) + 1/values_arr(i);
                end
                if end_node_arr(i) > 0
                    G(end_node_arr(i), end_node_arr(i)) = G(end_node_arr(i), end_node_arr(i)) + 1/values_arr(i);
                end
                if start_node_arr(i) > 0 && end_node_arr(i) > 0
                    G(start_node_arr(i), end_node_arr(i)) = G(start_node_arr(i), end_node_arr(i)) - 1/values_arr(i);
                    G(end_node_arr(i), start_node_arr(i)) = G(end_node_arr(i), start_node_arr(i)) - 1/values_arr(i);
                end

            case 'Voltage'
                % Voltage Source
                if start_node_arr(i) > 0
                    G(start_node_arr(i), max_node + voltage_source_index) = 1;
                    G(max_node + voltage_source_index, start_node_arr(i)) = 1;
                end
                if end_node_arr(i) > 0
                    G(end_node_arr(i), max_node + voltage_source_index) = -1;
                    G(max_node + voltage_source_index, end_node_arr(i)) = -1;
                end
                I(max_node + voltage_source_index) = values_arr(i);
                voltage_source_index = voltage_source_index + 1;

            case 'Current'
                % Current Source
                if start_node_arr(i) > 0
                    I(start_node_arr(i)) = I(start_node_arr(i)) - values_arr(i);
                end
                if end_node_arr(i) > 0
                    I(end_node_arr(i)) = I(end_node_arr(i)) + values_arr(i);
                end
        end
    end

    % Solve the matrix equation G * V = I
    V = G \ I;

    % Prepare the output
    output_str = '';
    for j = 1:max_node
        output_str = [output_str, sprintf('V(%d) = %.4f V\n', j, V(j))];
    end
    for k = 1:num_voltage_sources
        output_str = [output_str, sprintf('I(Vsource%d) = %.4f A\n', k, V(max_node + k))];
    end

    % Display the results in the solution panel
    set(handles.out_solution, 'String', output_str);


   

% --- Executes on button press in clear_button.
function clear_button_Callback(hObject, eventdata, handles)
    
    % Clear text fields
        set(handles.value_in, 'String', '');
        set(handles.node1_in, 'String', '');
        set(handles.node2_in, 'String', '');
        set(handles.error1, 'String', ' ');
        set(handles.error2, 'String', ' ');
        
    
     % Assuming the tag names for pop-up menus are 'component' and 'unit'
        component_popup = findobj(handles.figure1, 'Tag', 'component_menu');
        unit_popup = findobj(handles.figure1, 'Tag', 'unit_menu');
        
        % Clear the component pop-up menu
        set(component_popup, 'Value', 1); % Set to default value (e.g., first item)
        
        % Clear the unit pop-up menu
        set(unit_popup, 'Value', 1); % Set to default value (e.g., first item)
   
    % Clear solution text
        set(handles.out_solution, 'String', '');
   
   % Clear arrays
        handles.comonent_arr=[];
        handles.start_node_arr=[];
        handles.end_node_arr=[];
        handles.values_arr=[];
        
    % Reset component_counter
    handles.component_count = 0;
    
    % Update handles structure
    guidata(hObject, handles);

% --- Executes on button press in netlist_button.
function netlist_button_Callback(hObject, eventdata, handles)
     %get variables
      component_count  =handles.component_count;

    % Check if the netlist is empty
    if component_count == 0
        % Display an error message in the static text field 'error2'
        set(handles.error2, 'String', 'Error: The netlist is empty.');
    else

     % Initialize an empty output string
        output_str = ' ';
    
        output_str=char(10); %char(10) is the \n char
    % Loop through the arrays and build the output string
    for i = 1:component_count
        % Format each line with the component, start node, end node, and value
        line_str = sprintf('%s , Start Node: %d , End Node: %d , Value: %.2f\n' , ...
                           handles.component_arr{i}, ...
                           handles.start_node_arr(i), ...
                           handles.end_node_arr(i), ...
                           handles.values_arr(i));
        % Concatenate this line to the output string
        output_str = [output_str, line_str];
    end
    
    % Display the output string in the text box
    set(handles.out_solution, 'String',output_str);

    end

% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)

imshow('C:\Users\LaLaStore\Downloads\Untitled design (5).png');

  
 
