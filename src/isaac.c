#include "rand.h"
#include "erl_nif.h"
#include <string.h>

static ErlNifResourceType *RES_TYPE;
static ERL_NIF_TERM atom_ok;

static ERL_NIF_TERM
init(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
  struct randctx *ctx;
  int32_t *seed;
  ERL_NIF_TERM list, head, tail;
  int32_t seed_part;
  int i;
  ERL_NIF_TERM ret;

  ctx = enif_alloc_resource(RES_TYPE, sizeof(struct randctx));
  seed = enif_alloc_resource(RES_TYPE, sizeof(int32_t)*256);
  memset(seed,0,256);


  if (argc != 1)
  {
    return enif_make_badarg(env);
  }


  list = argv[0];
  if (!enif_is_list(env, list))
  {
    return enif_make_badarg(env);
  }
  

  /* We traverse the linked list until nil or 255 elems visited.  */

  for(i = 0; i < 256 && enif_get_list_cell(env,list, &head,&tail); i++, list  = tail)
  {
    if(!enif_get_int(env, head, &seed_part))
    {
      return enif_make_badarg(env);
    }
    seed[i] = seed_part;

  }

  ret = enif_make_resource(env,ctx);
  enif_release_resource(ctx);

  isaac_init(ctx, seed, i+1);

  return ret;
}

static ERL_NIF_TERM
next_int(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
  struct randctx *ctx;

  if (argc != 1)
  {
    return enif_make_badarg(env);
  }

  if (!enif_get_resource(env,argv[0],RES_TYPE, (void**) &ctx))
  {
    return enif_make_badarg(env);
  }

  return enif_make_int(env, isaac_next_int(ctx));
}

static ErlNifFunc funcs[] =
{
  { "init",     1, init,     0},
  { "next_int", 1, next_int, 0}
};


void
free_res(ErlNifEnv *env, void *obj)
{
  /*ctx is fully owned by its initial allocator. no extra resources to release*/
}

static int
load(ErlNifEnv *env, void **priv, ERL_NIF_TERM info)
{
  const char *mod;
  const char *name;
  int flags;

  mod = "Elixir.Isaac";
  name = "IsaacCtx";
  flags = ERL_NIF_RT_CREATE | ERL_NIF_RT_TAKEOVER;

  RES_TYPE = enif_open_resource_type(env,mod,name,free_res,flags,NULL);

  if (RES_TYPE == NULL)
  {
    return -1;
  }

  atom_ok = enif_make_atom(env,"ok");
  
  return 0;
}


ERL_NIF_INIT(Elixir.Isaac, funcs, &load,NULL,NULL,NULL)


