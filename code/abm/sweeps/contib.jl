#Collect targets
cond=findall(x->x==1, S2[:,7])
data = abm_dat[cond]
function collate(x)
    dat=x
    kdat=keys(dat)
    nk=length(kdat)
    nk=length(dat[1])
    iter = length(dat[1]["effort"][1,1,:])
    rnds = length(dat[1]["effort"][:,1,1])
    temp = zeros(?,nk,rnds, iter)
    temp2 = zeros(?, nk, rnds)
    d = zeros(rnds,nk)

    for nks in 1:nk
        for it in 1:iter
            temp1[nk,1,:,it]=median(dat[j]["limit"][:,:,i], dims = 2)
            temp1[nk,2,:,i]=mean(dat[j]["effort"][:,:,i], dims = 2)

        end

        for k in 1:11
            for i in 1:length(dat[1]["effort"][:,1,1])
                temp2[j,k,i]=nanmedian(temp1[j,k,i,:])
            end
        end


        for i = 1:11
            d[:,i] =  mean(temp2[:,i,:]', dims =2)
        end

        end

        limit = normalize(d[:,1])
        effort =d[:,2]
        harvest = normalize(d[:,3])
        differ = d[:,4]
        punish = d[:,5]
        stock = d[:,6]
        leak = d[:,7]
        punish2 = d[:,8]
        seized = d[:,9]
        seized2 =d[:,10]
        payoffR = d[:,11]

        output=Dict("effort" => effort,
        "limit" => limit,
        "stock" => stock,
        "harvest" => harvest,
        "differ" => punish,
        "punish" => effort,
        "leak" => leak,
        "punish2" => punish2,
        "seized" => seized,
        "seized2" => seized2,
        "payoffR" => payoffR,)

        return (output)
end
