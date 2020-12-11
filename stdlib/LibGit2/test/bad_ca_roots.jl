# This file is a part of Julia. License is MIT: https://julialang.org/license

module Test_LibGit2_https

using LibGit2, Test

ENV["JULIA_SSL_CA_ROOTS_PATH"] = joinpath(@__DIR__, "bad_ca_roots.pem")

mktempdir() do dir
    repo_url = "https://github.com/JuliaLang/Example.jl"

    @testset "HTTPS clone with bad CA roots fails" begin
        repo_path = joinpath(dir, "Example.HTTPS")
        c = LibGit2.CredentialPayload(allow_prompt=false, allow_git_helpers=false)
        redirect_stderr(devnull)
        err = try LibGit2.clone(repo_url, repo_path, credentials=c)
        catch err
            err
        end
        @test err isa LibGit2.GitError
        @test err.msg == "user rejected certificate for github.com"
    end
end

end # module
