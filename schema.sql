-- Create the gallery table
CREATE TABLE IF NOT EXISTS public.gallery (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT,
    caption TEXT,
    image_url TEXT NOT NULL,
    storage_path TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('events', 'meetings', 'celebrations', 'programs')),
    event_date DATE,
    is_published BOOLEAN DEFAULT true,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security (RLS) on the table
ALTER TABLE public.gallery ENABLE ROW LEVEL SECURITY;

-- Public read access to published items
CREATE POLICY "Public can view published gallery items" 
ON public.gallery FOR SELECT 
USING (is_published = true);

-- Authenticated users (Admin) can CRUD
CREATE POLICY "Admin can manage gallery items" 
ON public.gallery FOR ALL 
TO authenticated 
USING (true)
WITH CHECK (true);

-- Create a storage bucket for gallery images
INSERT INTO storage.buckets (id, name, public) 
VALUES ('gallery_images', 'gallery_images', true)
ON CONFLICT (id) DO NOTHING;

-- Storage Policies
-- Public can read images
CREATE POLICY "Public can view gallery images" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'gallery_images');

-- Admin can insert, update, delete images
CREATE POLICY "Admin can upload images" 
ON storage.objects FOR INSERT 
TO authenticated 
WITH CHECK (bucket_id = 'gallery_images');

CREATE POLICY "Admin can update images" 
ON storage.objects FOR UPDATE 
TO authenticated 
USING (bucket_id = 'gallery_images');

CREATE POLICY "Admin can delete images" 
ON storage.objects FOR DELETE 
TO authenticated 
USING (bucket_id = 'gallery_images');
