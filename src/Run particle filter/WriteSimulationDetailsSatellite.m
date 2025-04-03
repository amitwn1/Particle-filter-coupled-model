function [] = WriteSimulationDetailsSatellite(sim,files)

% % Add a text file with simulation details % %

% Open new text file for writing
fid=fopen(['PF results\',files.folderName,'\Simulation details.txt'],'w');

% Define a string with relevant details
f_flags = fields(sim.flags);
C1 = cell(1,length(f_flags));
C_str = '';

for i = 1:length(f_flags)
    C1{i} = [f_flags{i},'-',num2str(eval(['sim.flags.',f_flags{i}]))];
    C1_temp = [f_flags{i},'-',num2str(eval(['sim.flags.',f_flags{i}])),', '];
    C_str = [C_str,C1_temp];
end


text = ['Cultivar: ',sim.cultivar,... 
    '\n','Number of particles: ',num2str(size(sim.comb,1)),...
    '\n','Tunning factor for noise addition (epsilon) = ',num2str(sim.epsilon),...
    '\n','DAPs not considered in the simulation - ',mat2str(sim.removed_DAPs),....
    'Relations used in coupling scheme: \n',C_str,'\n\n'];

% Print details into the text file
fprintf(fid, text);

% Close file
fclose(fid);