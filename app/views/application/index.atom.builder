atom_feed(
  root_url: collection_url(page: params[:page], format: :html),
  language: I18n.locale,
  'xmlns:thr' => 'http://purl.org/syndication/thread/1.0'
) do |feed|
  feed.title(head_title)
  feed.updated(collection.first.try(:created_at))
  feed.icon "http://#{request.host}/favicon.ico"

  if collection.respond_to?(:total_pages) # WillPaginate::Collection
    feed.link(rel: :first, type: 'application/atom+xml', href: collection_url(format: :atom))
    feed.link(rel: :last, type: 'application/atom+xml', href: collection_url(format: :atom, page: collection.total_pages))
    if collection.previous_page
      feed.link(rel: :previous, type: 'application/atom+xml', href: collection_url(format: :atom, page: collection.previous_page))
    end
    if collection.next_page
      feed.link(rel: :next, type: 'application/atom+xml', href: collection_url(format: :atom, page: collection.next_page))
    end
  end

  if @user
    atom_author(feed, @user)
  end

  collection.each do |resource|
    feed.entry(resource, url: atom_entry_url(resource)) do |entry|
      entry.title(resource)

      if resource.respond_to?(:content)
        entry.content simple_format(resource.content), type: :html
      end

      if resource.respond_to?(:user)
        atom_author(entry, resource.user)
      end

      if resource.respond_to?(:keywords)
        atom_categories(entry, resource.keywords)
      end

      if resource.respond_to?(:comments)
        atom_replies(entry, resource)
      end

      if resource.respond_to?(:commentable) && resource.commentable.respond_to?(:comments)
        atom_in_reply_to(feed, resource.commentable)
      end
    end
  end
end
