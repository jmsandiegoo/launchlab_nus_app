/// Not used within flutter but a file to store the plv8 functions in supabase

try {
    plv8.elog(LOG, 'handle new team user trigger: started.');
  
    // -- add the new team user inside the group chat
    var team_chat_id = plv8.execute('SELECT id FROM public.team_chats WHERE team_id = $1 AND is_group_chat = $2 LIMIT 1', [NEW.team_id, true])[0].id;
    plv8.execute('INSERT INTO public.team_chat_users (chat_id, user_id) VALUES($1, $2)', [team_chat_id, NEW.user_id]);
    plv8.execute('INSERT INTO public.team_chat_events (chat_id, user_id, event_type) VALUES($1, $2, $3)', [team_chat_id, NEW.user_id, 'joined']);
  
    // -- Get the rest of team members aside from the newly joined one
    var members = plv8.execute('SELECT user_id FROM public.team_users WHERE user_id != $1 AND team_id = $2', [NEW.user_id, NEW.team_id]);
  
    for (var i = 0; i < members.length; i++) {
      var member = members[i];
      
      // -- Check if the chat room exists between the two members
      var chat_room = plv8.execute('SELECT public.team_chats.id, COUNT(public.team_chat_users.user_id)  FROM public.team_chats INNER JOIN public.team_chat_users ON public.team_chats.id = public.team_chat_users.chat_id WHERE public.team_chat_users.user_id IN ($1, $2) AND public.team_chats.is_group_chat = $3 AND public.team_chats.team_id = $4 GROUP BY public.team_chats.id HAVING COUNT(public.team_chat_users.user_id) >=2', [NEW.user_id, member.user_id, false, NEW.team_id]);
      
      plv8.elog(LOG, 'chat_room: ' + chat_room);

      if (chat_room.length > 0) {
        continue;
      }
  
      var uuid = plv8.execute('SELECT uuid_generate_v4()')[0].uuid_generate_v4;
  
      // -- create new chat room
      plv8.execute('INSERT INTO public.team_chats (id, team_id, is_group_chat) VALUES ($1, $2, $3)', [uuid, NEW.team_id, false]);
  
      // -- Add both users into the chat room
      plv8.execute('INSERT INTO public.team_chat_users (chat_id, user_id) VALUES($1, $2)', [uuid, member.user_id]);
      plv8.execute('INSERT INTO public.team_chat_users (chat_id, user_id) VALUES($1, $2)', [uuid, NEW.user_id]);
    }
    
    plv8.elog(LOG, 'handle new team user trigger: insert user chats done');
  
    return NEW;
  
} catch (error) {
    plv8.elog(ERROR, 'handle new team user trigger error:' + error.message);
} finally {
    plv8.elog(LOG, 'handle new team user trigger: finished');
}


// DELETE Team User Trigger
try {
    plv8.elog(LOG, 'handle delete team user trigger: started.');
  
    // -- add the new team user inside the group chat
    var team_chat_id = plv8.execute('SELECT id FROM public.team_chats WHERE team_id = $1 AND is_group_chat = $2 LIMIT 1', [OLD.team_id, true])[0].id;
    plv8.execute('DELETE FROM public.team_chat_users WHERE user_id = $1 AND chat_id = $2', [OLD.user_id, team_chat_id]);
    plv8.execute('INSERT INTO public.team_chat_events (chat_id, user_id, event_type) VALUES($1, $2, $3)', [team_chat_id, OLD.user_id, 'left']);

    plv8.elog(LOG, 'handle delete team user trigger: remove user from team chat done');
  
    return OLD;
  
} catch (error) {
    plv8.elog(ERROR, 'handle delete team user trigger error:' + error.message);
} finally {
    plv8.elog(LOG, 'handle delete team user trigger: finished');
}